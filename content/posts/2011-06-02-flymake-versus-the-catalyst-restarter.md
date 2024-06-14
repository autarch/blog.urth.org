---
title: Flymake Versus the Catalyst Restarter
author: Dave Rolsky
type: post
date: 2011-06-02T14:59:03+00:00
url: /2011/06/02/flymake-versus-the-catalyst-restarter/
---

I recently started using flymake-mode in emacs, which does a "make on the fly" for the buffer you're
currently editing. For Perl, that basically means checking the code by running `perl -c` on it. If
it sees any errors or warnings, it highlights this in the buffer. This is pretty handy for catching
typos, although I've seen some weird false positive. Anyway, it's a great tool, except that it does
its checking by creating a file in the same directory as the one you're editing. So if you're
editing `MyApp/lib/MyApp.pm`, flymake will create (and delete) a `MyApp/lib/MyApp_flymake.pm`.
Catalyst's Restarter watches the lib directory for file changes, and restarted the dev server on
each change. Combined with flymake, this means a lot of useless restarting. Fortunately, it's easy
enough to get flymake to create its files elsewhere. Here's a snippet that includes some code off
the [FlymakeRuby page on the Emacs Wiki][1]:

```lisp
(defun flymake-perl-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-intemp))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "/home/autarch/perl5/perlbrew/perls/current/bin/perl"
          (list "-MProject::Libs" "-wc" local-file)))
)
```

You can change the perl path to just be

`perl` or `/usr/bin/perl`. Obviously, I'm using perlbrew. I got most of this bit from [Damien
Krotkine's post on perlbrew and flymake][2], but I replaced the use of "flymake-create-temp-inplace"
with "flymake-create-temp-intemp", defined below.

```lisp
(defun flymake-create-temp-intemp (file-name prefix)
  "Return file name in temporary directory for checking
   FILE-NAME. This is a replacement for
   `flymake-create-temp-inplace'. The difference is that it gives
   a file name in `temporary-file-directory' instead of the same
   directory as FILE-NAME.

   For the use of PREFIX see that function.

   Note that not making the temporary file in another directory
   \(like here) will not if the file you are checking depends on
   relative paths to other files \(for the type of checks flymake
   makes)."
  (unless (stringp file-name)
    (error "Invalid file-name"))
  (or prefix
      (setq prefix "flymake"))
  (let* ((name (concat
                (file-name-nondirectory
                 (file-name-sans-extension file-name))
                "_" prefix))
         (ext  (concat "." (file-name-extension file-name)))
         (temp-name (make-temp-file name nil ext))
         )
    (flymake-log 3 "create-temp-intemp: file=%s temp=%s" file-name temp-name)
    temp-name))
```

This is the bit from the Emacs Wiki (thanks, whoever wrote this!). It tells flymake to make its
files in a temp directory.

```lisp
(setq temporary-file-directory "~/.emacs.d/tmp/")
```

You can set this to whatever you want. And poof, flymake is no longer making the Catalyst Restarter
work so hard.

[1]: http://www.emacswiki.org/emacs/FlymakeRuby
[2]: http://dams.github.com/2011/05/27/perlbrew-emacs-flymake.html

## Comments

**Erez, on 2011-06-02 15:48, said:**  
I stopped using Flymake because I'm using local::lib heavily, and flymake kept throwing errors about
not finding libraries in @INC, sadly ignoring those in ~/perl5/lib. I take it this workaround is for
the binary, not the libs, so it might not resolve my issue.

**Dave Rolsky, on 2011-06-02 17:02, said:**  
@Eretz: The last line of the first chunk constructs the arguments passed to the Perl binary. You
could change that to be smarter.

You might also consider just changing your PERL5LIB env var to include your local libs.

**dams, on 2011-06-07 09:54, said:**  
Have a look at Project::Libs, it also helps putting local libs in @INC on the fly

**Dave Rolsky, on 2011-06-07 09:56, said:**  
@dams: I was actually having the same problems that Erez having, even with Project::Libs. I've since
disabled flymake, but I plan to go back and figure out the problem at some point.

**genehack, on 2011-11-23 14:07, said:**  
Okay, I think I've finally got something based on Dave's code above that works for me. Assumes use
of Git in order to find a base project directory, and assumes libraries are found in $BASE/lib:

    (defun flymake-perl-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-intemp))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name)))
             ;;; this gives path to base project directory or nothing if
             ;;; we're not in a git tree.
             (include-path (shell-command-to-string
                            (format "cd %s && git rev-parse --show-cdup 2>/dev/null"
                                    (file-name-directory buffer-file-name)))))
        (if (string-equal include-path "")
            (setq perl-args "-wc")
          ;; remove the trailing newline
          (setq include-path
                (and include-path
                     (substring include-path 0
                                (- (length include-path) 1))))
          (setq perl-args (format "-wc -I%slib" include-path)))
        ;(message "PERL ARGS = '%s'" perl-args)
        (list "/opt/perl/bin/perl" (list perl-args local-file))))
