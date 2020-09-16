---
title: Am I a modern dinosaur?
author: Dave Rolsky
type: post
date: 2009-02-17T10:48:46+00:00
url: /2009/02/17/am-i-a-modern-dinosaur/
---
♪ I'm a dinosaur, somebody is digging my bones ♪ - King Crimson

I just read a [great article/talk by Charles Petzold][1] that was recently (re-)posted on reddit. He talks about how Windows IDEs have involved, and how they influence the way one programs.

Reading it, I was struck by just how _ancient_ the way I program is. I use Emacs, a distinctly non-visual editor. When I work on GUIs, I do it using HTML and CSS, which means I edit the GUI not using a GUI, but through a text interface. Then I have a separate application (my browser) in which I view the GUI.

My GUI development process involves tweaking the GUI definition (HTML & CSS), then reloading in the browser, and back and forth. All the actual GUI _behavior_ is separate yet again, divided between client-side code (Javascript) and server-side (a Catalyst app, these days).

This is truly an archaic way to program. Not only is my editor archaic, the very thing I'm developing is a thin client talking to a fat server. Of course, with Javascript, I can make my client a bit fatter, but this is still very much like a terminal talking to a mainframe.

But I like programming this way well enough, and it seems to produce reasonable results. There are plenty of good reasons for deploying and using thin clients, and Emacs is an immensely powerful tool. HTML and CSS suck big time, but my limited experience with "real" GUI programming suggests that's just as painful, if not more so.

But still, I feel like I'm old and grizzled before my time. Surely I should be using a powerful new-fangled editor with powerful new-fangled libraries. Bah, kids today and their GUIs!

 [1]: http://www.charlespetzold.com/etc/DoesVisualStudioRotTheMind.html

## Comments

**Micheal McEvoy, on 2009-02-17 13:55, said:**  
I agree. When I learned to prgram in MS Windows (Windows 3.11 was the current version), my professor would not allow us to use the Borland Windows Libraries. We had to roll our own. While in the real world, you wouldn't do this, it at least gave us an idea of what was going on in that "black box".

I do just about everything in Emacs, I cringe at badly designed and implemented "drag and drop" applications. It's just bad business practice, but that is why we are in the current economic situation as well.

I'm not sure that "us dinosaurs" could have done better, but at least we would know what was driving the system.

**Erez, on 2009-02-17 14:47, said:**  
I couldn't disagree more. Modern IDE are helpful, but also need to be handled very carefully. You need to know what you're doing, and you need to know what are the risks. At work, where I work with ASP.NET, we even got to a point where we consider forbidding the usage of the designer part of Visual Studio. 

There are many reasons. Using an IDE makes the programmer consider first the GUI, then the functionality. This results in a programmer that has a bottom-up way of thinking about his work. The designer component create the same style and logic definitions over and over, (not to mention the usual nomenclature, mainly "button1" "Panel\_Main\_4" etc.) and as result the source-code has multiple repetitions. Connecting elements in the program through the IDE result in no logical structure of code: an object calls a method which launches another element with no coherent lines of execution. Reading such programming (other than being tiresome on the eyes) is a very Zen-like experience (and not in a good way). Things "happen". Database results materialise wanton. Events are handled "during" their There is no way for the maintainer to know when things happen, and what leads to what.

I have attempted to maintain such code, which ended in long weeks of cleaning, refactoring, but usually ended with blind hacking and hard-coding workarounds. A bad programmer would've made similar errors with nothing but a text editor, but at least an editor doesn't encourage bad practices and enforce bad habits.

**Robert, on 2009-02-17 14:49, said:**  
Careful...I hear calling Emacs "archaic" can get you stoned and drawn and quartered. :-)

**Dave Rolsky, on 2009-02-17 14:54, said:**  
@Erez: I think you're taking my post too seriously. I love using Emacs, and I think there are many benefits to using it over an IDE. Also, given I mostly do Perl, many of the typical IDE benefits don't apply.

**Erez, on 2009-02-17 15:00, said:**  
Right. I realised that when I saw the article you referred to. You were just too sincere in your post, I really fell for it and rushed to the rescue. I agree with the article you linked all too well.

**Richard Huxton, on 2009-02-18 14:51, said:**  
If you want something a little more "modern" (in a 1980s vs 1970s sort of way) you might want to play with Seaside running on Squeak. It's got the grand-daddy of all IDEs and wraps the whole html/javascript stuff up quite neatly. The only things against it are that you need to be quite deep into it to do anything very useful and that there's no way of telling the 20% of good, reliable functionality from the 80% of neglected classes. Actually, that makes it sound like CPAN, but I found it worse than that.

I enjoyed exploring it a couple of years ago though, and Randall Schwartz is evangelizing about it at present.