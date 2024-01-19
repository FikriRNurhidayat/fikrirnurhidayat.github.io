;;; build --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Fikri Rahmat Nurhidayat
;;
;; Author: Fikri Rahmat Nurhidayat <https://github.com/fikrirnurhidayat>
;; Maintainer: Fikri Rahmat Nurhidayat <fikrirnurhidayat@gmail.com>
;; Created: December 20, 2021
;; Modified: December 20, 2021
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/fikrirnurhidayat/fikrirnurhidayat.github.io
;; Package-Requires: ((emacs "28.2"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;; This file is being used to configure how the site will be build
;;
;;  Description
;;; This file is being used to configure how the site will be build
;;
;;
;;; Code:
;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)
(package-install 'webfeeder)

;; Import publishing tools
(require 'org)
(require 'ox-publish)

(setq org-html-metadata-timestamp-format "%d %B %Y"
	  org-html-validation-link nil
      org-html-head-include-default-style nil
      org-export-headline-levels 6
      org-html-htmlize-output-type 'css
      org-html-head-include-scripts nil
      org-html-html5-fancy t
      org-html-coding-system 'utf-8-unix
      org-html-doctype "html5"
      org-html-divs '((preamble "header" "preamble")
                      (content "article" "content")
                      (postamble "footer" "postamble"))
      org-html-preamble-format '(("en" "<h1>%t</h1> <time>%d</time>"))
      org-html-postamble "<p>© 2021 Fikri Rahmat Nurhidayat</p>"
      org-html-head "<link rel=\"stylesheet\" href=\"/assets/css/main.css\">
                     <link rel=\"icon\" type=\"image/svg+xml\" href=\"/assets/favicon.svg\">")

;; Setup publishing
(setq org-publish-project-alist
      '(("site:content"
         :recursive t
         :auto-preamble t
         :auto-postamble t
         :base-directory "./content"
		     :base-extension "org"
		     :exclude "posts/*"
         :publishing-directory "./dist"
         :with-author nil
         :with-title nil
         :with-toc nil
         :with-date t
         :with-timestamps nil
         :section-numbers nil
         :publishing-function org-html-publish-to-html)
		    ("site:posts"
         :recursive t
         :auto-sitemap t
		     :sitemap-title "Posts"
		     :sitemap-filename "posts.org"
		     :sitemap-format-entry fain/org-publish-sitemap-entry
		     :sitemap-sort-files anti-chronologically
		     :sitemap-style list
         :auto-preamble t
         :auto-postamble t
         :base-directory "./content"
		     :base-extension "org"
		     :exclude "about.org"
         :publishing-directory "./dist"
         :with-author nil
         :with-title nil
         :with-toc nil
         :with-date t
         :with-timestamps nil
         :section-numbers nil
         :publishing-function org-html-publish-to-html)
        ("site:assets"
         :recursive t
         :base-directory "./assets"
         :base-extension "html\\|xml\\|css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|zip\\|gz\\|csv\\|m\\|R\\|el\\|svg\\|webp"
         :publishing-directory "./dist/assets"
         :publishing-function org-publish-attachment)
        ("site:html"
         :recursive t
         :base-directory "./content"
         :base-extension "html"
         :publishing-directory "./dist"
         :publishing-function org-publish-attachment)
        ("site" :components ("site:html" "site:content" "site:posts" "site:assets"))))

(setq org-export-global-macros
      '(("time" . "@@html:<br><time>$1</time>@@")))

(defun fain/org-publish-sitemap-entry (entry style project)
  "Fain's format for site map ENTRY, as a string.
ENTRY is a file name.  STYLE is the style of the sitemap.
PROJECT is the current project."
  (cond
   ((not (directory-name-p entry))
	  (format "[[file:%s][%s]] {{{time(%s)}}}"
			      entry
			      (org-publish-find-title entry project)
            (format-time-string "%B %e&#44; %Y" (seconds-to-time (org-publish-find-date entry project)))))
   ((eq style 'tree)
	  ;; Return only last subdir.
	  (file-name-nondirectory (directory-file-name entry)))
   (t entry)))

(defun fain/publish ()
  "Publish the website."
  (org-publish-all)
  (make-directory "dist/rss" t)
  (webfeeder-build "rss/posts.xml"
                   "./dist"
                   "https://fikrirnurhidayat.com"
                   (let ((default-directory (expand-file-name "./dist/")))
                     (directory-files-recursively "posts"
                                                  ".*\\.html$"))
                   :builder 'webfeeder-make-rss
                   :title "Fikri Rahmat Nurhidayat"
                   :description "Random thought."
                   :author "Fikri Rahmat Nurhidayat"))

(provide 'build)
;;; build.el ends here
