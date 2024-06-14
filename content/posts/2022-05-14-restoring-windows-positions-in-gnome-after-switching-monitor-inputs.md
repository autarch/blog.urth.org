---
title: Restoring Window Positions in GNOME After Switching Monitor Inputs
author: Dave Rolsky
type: post
date: 2022-05-14T14:05:58-05:00
url: /2022/05/14/restoring-window-positions-in-gnome-after-switching-monitor-inputs
discuss:
  - site: "/r/programming"
    uri: "https://www.reddit.com/r/programming/comments/uptkgf/restoring_window_positions_in_gnome_after/"
  - site: "Hacker News"
    uri: "https://news.ycombinator.com/item?id=31383892"
---

I suspect that this title makes no sense to most people, so here's the background.

Like most normal people, I have four[^1] computers in my office. I used to have three, but that was
shameful, so I was very relieved to get a new laptop for my new job at
[MongoDB](https://www.mongodb.com/).

A while back, I bought
[a USB switching device with a remote](https://smile.amazon.com/gp/product/B083JKDNRJ). This
eliminated the need to physically switch my USB hub's cable from one computer to another.

I have two monitors connected to these computers, and I switch between inputs on the monitors when I
switch computers. I used to do this manually by using the buttons on the monitors, but this was
annoying. I've used KVM switches before but my experience has been that they're all junk, so I
didn't want to go that route again.

Fortunately, I found an
[awesome project in Rust called display-switch](https://github.com/haimgel/display-switch) created
by [Haim Gelfenbeyn](https://github.com/haimgel). It runs on Linux, macOS, and Windows as a
background service. It listens for USB connect/disconnect events and then uses
[DDC](https://en.wikipedia.org/wiki/Display_Data_Channel) commands to switch the inputs on the
monitor. With this configured on each computer, I can use the USB switch's remote to switch all the
USB devices _and_ the monitors together. It's great!

And for a while, everything worked fine. I'd switch to my Windows computer for gaming, then back to
Linux for day-to-day work and computing. But for some reason when I added my work laptop to the mix,
something went wrong on my personal Linux desktop.

Suddenly, when the monitors switched,
[mutter](<https://en.wikipedia.org/wiki/Mutter_(software)>)[^2] would move all the windows on my
left monitor onto the right monitor. This was very, very annoying.

Surely, I thought, there must be a way to fix this. The actual issue has been discussed in various
forums for quite a few years. Here's
[a bug report for mutter on the topic](https://gitlab.gnome.org/GNOME/mutter/-/issues/1419), which
has links to more bugs for Red Hat, Ubuntu, and gnome-shell.

I don't think this had anything to do with my work laptop, exactly. Instead, it's probably because I
shifted some cabling around when I added my work laptop to the mix, moving my personal Linux desktop
from HDMI1 to DisplayPort2 on my left monitor. This in turn changes the timing of when the monitor
sleeps and wakes when the input is switched, and mutter reacts by moving all my windows around.

The `display-switch` project lets you run arbitrary commands when the USB device disconnects and
connects. I wanted to use this to keep my windows where I put them.

In reading about the issue, I found some workarounds people had come up with, including a very
creative one using [`wmctrl`](https://linux.die.net/man/1/wmctrl). But `wmctrl` only works with X
and X is going away in favor of Wayland.

But then I read some more and discovered that Gnome has a
[comprehensive JavaScript binding](https://gjs.guide/) that you can invoke with some `dbus` magic:

```
$> gdbus call \
       --session \
       --dest org.gnome.Shell \
       --object-path /org/gnome/Shell \
       --method org.gnome.Shell.Eval \
       "some_js_stuff(); and_more();"
```

Could I use this to somehow save and restore my windows? Yes, I could! When you run this command,
you will get some output to `stdout` like this:

```
$> gdbus call \
       --session \
       --dest org.gnome.Shell \
       --object-path /org/gnome/Shell \
       --method org.gnome.Shell.Eval \
       '42'
(true, '42')

$> gdbus call \
       --session \
       --dest org.gnome.Shell \
       --object-path /org/gnome/Shell \
       --method org.gnome.Shell.Eval \
       'throw "Foo"'
(false, 'Foo')
```

The output is a list where the first item is a boolean indicating whether the code threw an error (I
think), and the second is the error output _or_ the value of the last statement executed.

So I wrote a little Perl script to execute the JS I needed and parse the output to check if it
worked.

Here's the code in full:

```perl
#!/usr/bin/env perl

use v5.32;
use strict;
use warnings;
use autodie qw( :all );
use Capture::Tiny qw( capture_stdout );
use JSON::MaybeXS qw( decode_json encode_json );
use Path::Tiny qw( path );

my $POSITION_FILE
    = path('/home/autarch/.config/display-switch/window-positions.json');

sub main {
    if ( @ARGV && $ARGV[0] eq 'restore' ) {
        restore();
    }
    elsif ( @ARGV && $ARGV[0] eq 'save' ) {
        save();
    }
    else {
        die q{You must specify 'save' or 'restore' as an argument'};
    }
}

my $SAVE_JS = <<'EOF';
const { Gio, GLib } = imports.gi;
let windows = {};
global.get_window_actors().forEach(function (window) {
    let mw = window.meta_window;
    let rect = mw.get_frame_rect();
    let title = mw.get_title();
    if (title === null || title === "gnome-shell") {
        return;
    }
    let id = mw.get_id();
    let w = {
        title: title,
        monitor: mw.get_monitor(),
        x: rect.x,
        y: rect.y,
        w: rect.width,
        h: rect.height,
    };
    windows[id] = w;
});

const filepath = GLib.build_filenamev([
    GLib.get_home_dir(),
    ".config",
    "display-switch",
    "window-positions.json",
]);
const file = Gio.File.new_for_path(filepath);
const [ok] = file.replace_contents(
    JSON.stringify(windows),
    null,
    false,
    Gio.FileCreateFlags.REPLACE_DESTINATION,
    null
);
if (!ok) {
    log("Could not write to file at " + filepath);
}
EOF

sub save {
    run_js($SAVE_JS);
}

my $RESTORE_JS = <<'EOF';
const { Gio, GLib } = imports.gi;
const filepath = GLib.build_filenamev([
    GLib.get_home_dir(),
    ".config",
    "display-switch",
    "window-positions.json",
]);
const file = Gio.File.new_for_path(filepath);
const [ok, contents] = file.load_contents(null);
if (!ok) {
    log("Could not read from file at " + filepath);
}
const windows = JSON.parse(contents.toString());

global.get_window_actors().forEach(function (window) {
    let mw = window.meta_window;
    let rect = mw.get_frame_rect();
    let id = mw.get_id();
    let w = windows[id];
    if (w === null || w === undefined) {
        return;
    }
    mw.move_to_monitor(w.monitor);
    mw.move_resize_frame(true, w.x, w.y, w.w, w.h);
});
EOF

sub restore {

    # waiting for the monitor to be active again.
    sleep(5);
    run_js($RESTORE_JS);
}

sub run_js {
    my $js      = shift;
    my @command = (
        qw( gdbus call), '--session', qw( --dest org.gnome.Shell ),
        qw( --object-path /org/gnome/Shell ),
        qw( --method org.gnome.Shell.Eval)
    );
    my $stdout = capture_stdout(
        sub {
            system( @command, $js );
        }
    );
    $stdout =~ s/^\(|\)$//g;
    my ( $ok, $err ) = split /\s*,\s*/, $stdout, 2;
    die "Error running GJS: $err" unless $ok eq 'true';
}

main();
```

The Perl parts aren't that interesting. It's the JS that's doing all the work. Here's the code to
save the window positions:

```js
const { Gio, GLib } = imports.gi;
let windows = {};
global.get_window_actors().forEach(function (window) {
  let mw = window.meta_window;
  let rect = mw.get_frame_rect();
  let title = mw.get_title();
  if (title === null || title === "gnome-shell") {
    return;
  }
  let id = mw.get_id();
  let w = {
    title: title,
    monitor: mw.get_monitor(),
    x: rect.x,
    y: rect.y,
    w: rect.width,
    h: rect.height,
  };
  windows[id] = w;
});

const filepath = GLib.build_filenamev([
  GLib.get_home_dir(),
  ".config",
  "display-switch",
  "window-positions.json",
]);
const file = Gio.File.new_for_path(filepath);
const [ok] = file.replace_contents(
  JSON.stringify(windows),
  null,
  false,
  Gio.FileCreateFlags.REPLACE_DESTINATION,
  null,
);
if (!ok) {
  log("Could not write to file at " + filepath);
}
```

This loops through all the windows and records information for each window. It saves the monitor the
window is on, its unique ID, its X & Y position, and its height & width. This gets written as JSON
to a file every time the USB device is disconnected.

One odd thing is that `global.get_window_actors()` includes one window with a `null` title and
another window for the `gnome-shell` process. I'm not sure what that `null` title window is, but
it's best to just skip it and `gnome-shell`.

The restore code is even simpler:

```js
const { Gio, GLib } = imports.gi;
const filepath = GLib.build_filenamev([
  GLib.get_home_dir(),
  ".config",
  "display-switch",
  "window-positions.json",
]);
const file = Gio.File.new_for_path(filepath);
const [ok, contents] = file.load_contents(null);
if (!ok) {
  log("Could not read from file at " + filepath);
}
const windows = JSON.parse(contents.toString());

global.get_window_actors().forEach(function (window) {
  let mw = window.meta_window;
  let rect = mw.get_frame_rect();
  let id = mw.get_id();
  let w = windows[id];
  if (w === null || w === undefined) {
    return;
  }
  mw.move_to_monitor(w.monitor);
  mw.move_resize_frame(true, w.x, w.y, w.w, w.h);
});
```

It loads the saved window position info, then matches the current windows against the IDs of the
saved windows. When there's a match, it restores the window to the correct monitor, then set its
position and size.

One other thing to note is the `sleep(5)` in the Perl code's `restore` subroutine. The program needs
to wait for the monitor's input change to take effect, or else none of this works. It'd be nice if
`display-switch` offered an `on_monitor_input_change_execute` config option, but I'm not sure if
that's even possible. The `sleep` is a hack, but it works fine, so it's good enough for now.

I just got a docking station for my work laptop, so I'll be able to connect it to both my monitors
as well, and I can use this program on that computer too if I need to.

I'm quite pleased with this solution. I thought it might be anywhere from very hard to impossible,
but this turned out to be fairly easy. Most of my time was spent simply reading about the problem
before discovering the Gnome JS API. Once I knew that API existed, the actual implementation was
fairly easy.

I also want to credit
[this /r/gnome post](https://www.reddit.com/r/gnome/comments/lwrs1p/moving_and_resizing_windows_programmatically_on/)
by [MortimerErnest](https://www.reddit.com/user/MortimerErnest/), which links to
[a bash script they wrote](https://gist.github.com/MortenStabenau/130a35a0f2b57b09ca518d202bac0bbe).
Reading that script made it quite obvious how I could use the Gnome JS API for my own problem.

[^1]:
    Well, more than four, because I also have a NAS, a network router, a Nintendo Switch, a PS5 in
    the closet, an iPad mini in the same closet, and a Raspberry Pi I bought over a year ago with
    which I intended to build an LCD panel clock, though I've not done so yet. And my phone is also
    a computer. This is a very normal number of computers to have.

[^2]: The default window manager for GNOME since GNOME 3.
