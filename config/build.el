;;; build --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Fikri Rahmat Nurhidayat
;;
;; Author: Fikri Rahmat Nurhidayat <https://github.com/fain>
;; Maintainer: Fikri Rahmat Nurhidayat <fikrirnurhidayat@gmail.com>
;; Created: December 20, 2021
;; Modified: December 20, 2021
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/fain/build-config
;; Package-Requires: ((emacs "24.3"))
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
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Import publishing tools
(require 'org)
(require 'ox-publish)

(setq org-html-validation-link nil
      org-html-head-include-default-style nil
      org-export-headline-levels 5
      org-html-head-include-scripts nil
      org-html-html5-fancy t
      org-html-coding-system 'utf-8-unix
      org-html-divs '((preamble "div" "preamble")
                     (content "main" "content")
                     (postamble "footer" "postamble"))
      org-html-postamble "<p>© 2021 Fikri Rahmat Nurhidayat</p>"
      org-html-head "<link rel=\"stylesheet\" href=\"/assets/css/main.css\">
                     <link rel=\"icon\" type=\"image/svg+xml\" href=\"/assets/favicon.svg\">")

;; Setup publishing
(setq org-publish-project-alist
      '(("site:main"
             :recursive t
             :base-directory "./content"
             :publishing-directory "./dist"
             :auto-sitemap t
             :with-author nil
             :with-toc t
             :with-timestamps t
             :section-numbers nil
             :publishing-function org-html-publish-to-html)
        ("site:assets"
             :recursive t
             :base-directory "./assets"
             :base-extension "html\\|xml\\|css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|zip\\|gz\\|csv\\|m\\|R\\|el\\|svg"
             :publishing-directory "./dist/assets"
             :publishing-function org-publish-attachment)
        ("site" :components ("site:main" "site:assets"))))
(provide 'build)
;;; build.el ends here
