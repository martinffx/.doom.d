;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Martin C. Richards"
      user-mail-address "martincharlesrichards@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq
 doom-font (font-spec :family "Fira Code" :size 12)
 projectile-project-search-path '("~/code"))
(add-to-list 'default-frame-alist '(fullscreen . maximized))


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(global-set-key (kbd "C-=") #'er/expand-region)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq
 projectile-project-search-path '("~/code")
 lsp-log-io 't
 cljr-suppress-middleware-warnings 't
 cider-clojure-cli-aliases "dev:test"
 lsp-java-vmargs '("-noverify" "-Xmx1G" "-XX:+UseG1GC" "-XX:+UseStringDeduplication" "-javaagent:/Users/martinrichards/.m2/repository/org/projectlombok/lombok/1.18.10/lombok-1.18.10.jar" "-Xbootclasspath/a:/Users/martinrichards/.m2/repository/org/projectlombok/lombok/1.18.10/lombok-1.18.10.jar"))

;; AVY
(map! :leader
      :prefix "j"
      "f" #'avy-goto-char
      "s" #'avy-goto-char-2
      "j" #'avy-goto-line
      "w" #'avy-goto-word-0)

;; Search
;; (use-package! deadgrep
;;   :if (executable-find "rg")
;;   :init
;;   (map! "M-s" #'deadgrep))

;; (map! "C-s" 'counsel-grep-or-swiper)

;; projectile
(map! :leader
      :prefix "p"
      "t" #'treemacs)
