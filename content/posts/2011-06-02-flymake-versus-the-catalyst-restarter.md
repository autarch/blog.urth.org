---
title: Flymake Versus the Catalyst Restarter
author: Dave Rolsky
type: post
date: 2011-06-02T14:59:03+00:00
url: /2011/06/02/flymake-versus-the-catalyst-restarter/
categories:
  - Uncategorized

---
I recently started using flymake-mode in emacs, which does a &#8220;make on the fly&#8221; for the buffer you&#8217;re currently editing. For Perl, that basically means checking the code by running `perl -c` on it. If it sees any errors or warnings, it highlights this in the buffer. This is pretty handy for catching typos, although I&#8217;ve seen some weird false positive. Anyway, it&#8217;s a great tool, except that it does its checking by creating a file in the same directory as the one you&#8217;re editing. So if you&#8217;re editing `MyApp/lib/MyApp.pm`, flymake will create (and delete) a `MyApp/lib/MyApp_flymake.pm`. Catalyst&#8217;s Restarter watches the lib directory for file changes, and restarted the dev server on each change. Combined with flymake, this means a lot of useless restarting. Fortunately, it&#8217;s easy enough to get flymake to create its files elsewhere. Here&#8217;s a snippet that includes some code off the [FlymakeRuby page on the Emacs Wiki][1]:

<pre class="lang:lisp">(defun flymake-perl-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-intemp))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "/home/autarch/perl5/perlbrew/perls/current/bin/perl"
          (list "-MProject::Libs" "-wc" local-file)))
)
</pre>

You can change the perl path to just be

`perl` or `/usr/bin/perl`. Obviously, I&#8217;m using perlbrew. I got most of this bit from [Damien Krotkine&#8217;s post on perlbrew and flymake][2], but I replaced the use of &#8220;flymake-create-temp-inplace&#8221; with &#8220;flymake-create-temp-intemp&#8221;, defined below.

<pre class="lang:lisp">(defun flymake-create-temp-intemp (file-name prefix)
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
</pre>

This is the bit from the Emacs Wiki (thanks, whoever wrote this!). It tells flymake to make its files in a temp directory.

<pre class="lang:lisp">(setq temporary-file-directory "~/.emacs.d/tmp/")
</pre>

You can set this to whatever you want. And poof, flymake is no longer making the Catalyst Restarter work so hard.

 [1]: http://www.emacswiki.org/emacs/FlymakeRuby
 [2]: http://dams.github.com/2011/05/27/perlbrew-emacs-flymake.html

## Comments

### Comment by Erez on 2011-06-02 15:48:00 -0500
I stopped using Flymake because I&#8217;m using local::lib heavily, and flymake kept throwing errors about not finding libraries in @INC, sadly ignoring those in ~/perl5/lib. I take it this workaround is for the binary, not the libs, so it might not resolve my issue.

### Comment by Dave Rolsky on 2011-06-02 17:02:16 -0500
@Eretz: The last line of the first chunk constructs the arguments passed to the Perl binary. You could change that to be smarter.

You might also consider just changing your PERL5LIB env var to include your local libs.

### Comment by dams on 2011-06-07 09:54:52 -0500
Have a look at Project::Libs, it also helps putting local libs in @INC on the fly

### Comment by Dave Rolsky on 2011-06-07 09:56:44 -0500
@dams: I was actually having the same problems that Erez having, even with Project::Libs. I&#8217;ve since disabled flymake, but I plan to go back and figure out the problem at some point.

### Comment by genehack on 2011-11-23 14:07:10 -0600
Okay, I think I&#8217;ve finally got something based on Dave&#8217;s code above that works for me. Assumes use of Git in order to find a base project directory, and assumes libraries are found in $BASE/lib: 

    
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