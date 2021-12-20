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
(require 'htmlize)
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
      org-html-head "<link rel=\"stylesheet\" href=\"/assets/css/main.css\">")

;; Setup publishing
(setq org-publish-project-alist
      '(("site:main"
             :recursive t
             :base-directory "./content"
             :publishing-directory "./dist"
             :auto-sitemap t
             :sitemap-filename "sitemap.org"
             :sitemap-title "My Journal"
             :sitemap-style list
             :with-author nil
             :with-toc t
             :with-timestamps t
             :section-numbers nil
             :publishing-function org-html-publish-to-html)
        ("site:assets"
             :recursive t
             :base-directory "./assets"
             :base-extension "html\\|xml\\|css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|zip\\|gz\\|csv\\|m\\|R\\|el"
             :publishing-directory "./dist/assets"
             :publishing-function org-publish-attachment)
        ("site" :components ("site:main" "site:assets"))))
