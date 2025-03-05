(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'htmlize)
  (package-refresh-contents)

  (package-install 'htmlize)
  (package-install 'rainbow-delimiters)
  (package-install 'weblorg))

;; Configure dependencies
(require 'ox-html)

;; Output HTML with syntax highlight with css classes instead of
;; directly formatting the output.
(setq org-html-htmlize-output-type 'css)

;; For syntax highlight of blocks containing these types of code
;; (require 'effigy-mode)
;; (require 'peg-mode)
;; (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(require 'weblorg)

(setq weblorg-default-url "https://fikrirnurhidayat.com")

(weblorg-site
 :template-vars '(("site_name" . "Fikk")
                  ("site_owner" . "fikrirnurhidayat@gmail.com (Fikk)")
                  ("site_description" . "Fikk's personal blog.")))

(weblorg-route
 :name "posts"
 :input-pattern "posts/**/*.org"
 :output "output/blog/{{ slug }}.html"
 :template "post.html"
 :url "/blog/{{ slug }}.html")

(weblorg-route
 :name "index"
 :input-pattern "posts/**/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :output "output/index.html"
 :template "index.html"
 :url "/")

(weblorg-route
 :name "rss"
 :input-pattern "posts/**/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "rss.xml"
 :output "output/rss.xml"
 :url "/rss.xml")

;; route for static assets that also copies files to output directory
(weblorg-copy-static
 :output "output/{{ file }}"
 :url "/{{ file }}")

;; fire the engine and export all the files declared in the routes above
(weblorg-export)
