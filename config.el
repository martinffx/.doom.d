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
 projectile-project-search-path '("~/code/onoconnect" "~/code/play" "~/code/work"))
(add-to-list 'default-frame-alist '(fullscreen . maximized))


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

(setq
 org-directory "~/Dropbox/org"
 +org-capture-todo-file "~/Dropbox/org/inbox.org"
 org-tag-alist (quote (("@errand" . ?e)
                       ("@office" . ?o)
                       ("@home" . ?h)
                       ("@phone" . ?p)
                       ("@computer" . ?c)
                       (:newline)
                       ("WAITING" . ?w)
                       ("HOLD" . ?H)
                       ("CANCELLED" . ?c)))
 org-refile-targets '(("~/Dropbox/org/gtd.org" :maxlevel . 3)
                      ("~/Dropbox/org/someday.org" :level . 1)
                      ("~/Dropbox/org/tickler.org" :maxlevel . 2))
 +notmuch-sync-backend 'offlineimap
 +notmuch-mail-folder "~/mail"
 cider-clojure-cli-parameters "-Adev")



;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(after! org-agenda
  (defun martinfx/org-agenda-skip-all-siblings-but-first ()
    "Skip all but the first non-done entry."
    (let (should-skip-entry)
      (unless (martinffx/org-current-is-todo)
        (setq should-skip-entry t))
      (save-excursion
        (while (and (not should-skip-entry) (org-goto-sibling t))
          (when (martinffx/org-current-is-todo)
            (setq should-skip-entry t))))
      (when should-skip-entry
        (or (outline-next-heading)
            (goto-char (point-max))))))

  (defun martinffx/org-current-is-todo ()
    (string= "TODO" (org-get-todo-state)))
  
  (setq
   org-agenda-files '("~/Dropbox/org/inbox.org"
                    "~/Dropbox/org/gtd.org"
                    "~/Dropbox/org/tickler.org"
                    "~/Dropbox/onoconnect.cal.org"
                    "~/Dropbox/martincharlesrichards.cal.org")
   org-agenda-custom-commands
      '(("o" "At the office" tags-todo "@office"
         ((org-agenda-overriding-header "Office")
          (org-agenda-skip-function #'martinfx/org-agenda-skip-all-siblings-but-first)))
        ("e" "Running an Errand" tags-todo "@errand"
         ((org-agenda-overriding-header "Errand")
          (org-agenda-skip-function #'martinfx/org-agenda-skip-all-siblings-but-first)))
        ("h" "At the home" tags-todo "@home"
         ((org-agenda-overriding-header "Home")
          (org-agenda-skip-function #'martinfx/org-agenda-skip-all-siblings-but-first)))
        ("p" "Phone" tags-todo "@phone"
         ((org-agenda-overriding-header "Phone")
          (org-agenda-skip-function #'martinfx/org-agenda-skip-all-siblings-but-first)))
        ("h" "Computer" tags-todo "@computer"
         ((org-agenda-overriding-header "Computer")
          (org-agenda-skip-function #'martinfx/org-agenda-skip-all-siblings-but-first))))))

(after! org-gcal
  (setq
    org-gcal-client-id "221636378744-1pmlieecf2ojishh09bifjhc5c703ps6.apps.googleusercontent.com"
    org-gcal-client-secret "tuxgtnpSSLK8xSD_O7R0of3E"
    org-gcal-up-days 7
    org-gcal-down-days 30
    org-gcal-file-alist '(("martin@onoconnect.com" . "~/Dropbox/org/onoconnect.cal.org")
                          ("martincharlesrichards@gmail.com" . "~/Dropbox/org/martincharlesrichards.cal.org"))))




(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-super-agenda-groups
        '((:name "In Progress"
                 :order 1
                 :todo "STRT")
          (:name "Today"
                 :order 2
                 :time-grid t
                 :deadline today
                 :and (:scheduled today :not (:habit)))
          (:name "Important"
                 :order 3
                 :priority "A")

          (:name "Due soon"
                 :order 5
                 :deadline future)
          (:order-multi (6 (:name "Office"
                                  :tag "@office")
                           (:name "Errands"
                                  :tag "@errands")
                           (:name "Home"
                                  :tag "@home")))
          (:name "Habits"
                 :order 7
                 :habit)
          (:name "Overdue"
                 :order 10
                 :deadline past)
          (:todo "WAITING"
                 :tag "WAITING"
                 :order 8)))
  :config
  (org-super-agenda-mode))


(map! :leader
      :prefix "n"
      (:prefix ("k" . "calendar")
        "a" #'cfw:open-org-calendar
        "f" #'org-gcal-fetch
        "s" #'org-gcal-sync
        "u" #'org-gcal-post-at-point
        "d" #'org-gcal-delete-at-point))

;; AVY
(map! :leader
      :prefix "j"
      "j" #'avy-goto-char
      "s" #'avy-goto-char-2
      "f" #'avy-goto-line
      "w" #'avy-goto-word-0)

;; Search
(use-package! deadgrep
  :if (executable-find "rg")
  :init
  (map! "M-s" #'deadgrep))

;; projectile
(map! :leader
      :prefix "p"
      "t" #'treemacs)

;; Merge conflicts
(use-package! smerge-mode
  :bind (("C-c h s" . martinffx/hydra-smerge/body))
  :init
  (defun martinffx/enable-smerge-maybe ()
    "Auto-enable `smerge-mode' when merge conflict is detected."
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward "^<<<<<<< " nil :noerror)
        (smerge-mode 1))))
  (add-hook 'find-file-hook #'martinffx/enable-smerge-maybe :append)
  :config
  (defhydra martinffx/hydra-smerge (:color pink
                                           :hint nil
                                           :pre (smerge-mode 1)
                                           ;; Disable `smerge-mode' when quitting hydra if
                                           ;; no merge conflicts remain.
                                           :post (smerge-auto-leave))
    "
   ^Move^       ^Keep^               ^Diff^                 ^Other^
   ^^-----------^^-------------------^^---------------------^^-------
   _n_ext       _b_ase               _<_: upper/base        _C_ombine
   _p_rev       _u_pper           g   _=_: upper/lower       _r_esolve
   ^^           _l_ower              _>_: base/lower        _k_ill current
   ^^           _a_ll                _R_efine
   ^^           _RET_: current       _E_diff
   "
    ("n" smerge-next)
    ("p" smerge-prev)
    ("b" smerge-keep-base)
    ("u" smerge-keep-upper)
    ("l" smerge-keep-lower)
    ("a" smerge-keep-all)
    ("RET" smerge-keep-current)
    ("\C-m" smerge-keep-current)
    ("<" smerge-diff-base-upper)
    ("=" smerge-diff-upper-lower)
    (">" smerge-diff-base-lower)
    ("R" smerge-refine)
    ("E" smerge-ediff)
    ("C" smerge-combine-with-next)
    ("r" smerge-resolve)
    ("k" smerge-kill-current)
    ("q" nil "cancel" :color blue)))
