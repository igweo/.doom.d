;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

;; THEME
(setq doom-theme 'doom-homage-black)
(setq fancy-splash-image "~/.doom.d/doom-splash.png")

;; FONTS
(setq doom-font (font-spec :family "Iosevka Nerd Font Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 13)
      doom-symbol-font (font-spec :family "all-the-icons") ;; this is key
      doom-unicode-font (font-spec :family "all-the-icons"))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; KEYBINDS
(map! :leader
      (:prefix ("f" . "files")
       :desc "Recent files" "o" #'recentf-open-files))

(map! :leader
      :desc "M-x" "e" #'execute-extended-command)

(map! :leader
      :prefix "w"
      :desc "Switch window"
      "w" #'other-window)

(map! :leader
      :desc "Lookup Fast"
      "o e" #'my/split-and-eww)

(map! :leader
      :desc "Rename symbol"
      "r" #'tide-rename-symbol)
;;TRAMP
;;
(use-package tramp
  :config
  (setq tramp-default-method "ssh")
  (setq tramp-ssh-controlmaster-options "")
  (setq tramp-verbose 10))  ;; Increase verbosity for debugging

(setq backup-directory-alist '(("." . "/tmp/")))
;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;; SHELL

(setq vterm-shell "/usr/bin/zsh")
;;; header-gen.el --- Auto-generate file and function headers -*- lexical-binding: t; -*-
;;;
;;;
;;;

;; ORG-MODE
(use-package! org-alert
  :after org
  :config
  (setq org-alert-interval 300 ; check every 5 minutes
        org-alert-notification-title "Org Reminder"
        org-alert-notify-cutoff 10 ; show alerts for tasks due in 10 minutes
        org-alert-notify-after-event-cutoff 10 ; keep showing for 10 mins after
        org-alert-days-to-alert 1 ; look up to 1 day ahead
        org-alert-bell nil ; set to t to ring system bell
        )
  (org-alert-enable))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/inbox.org" "Tasks")
         "* TODO %?\n  %U\n  %a")
        ("r" "Reminder" entry (file+headline "~/org/inbox.org" "Reminders")
         "* TODO %?\n  DEADLINE: %^T\n  %U")))

(use-package! org-pomodoro
  :after org
  :config
  (setq org-pomodoro-length 25
        org-pomodoro-short-break-length 5
        org-pomodoro-long-break-length 15
        org-pomodoro-play-sounds t
        org-pomodoro-audio-player "/usr/bin/afplay" ;; or aplay, paplay, mpg123
        org-pomodoro-start-sound "~/.doom.d/sounds/start.wav"
        org-pomodoro-break-sound "~/.doom.d/sounds/break.wav"
        org-pomodoro-finished-sound "~/.doom.d/sounds/done.wav"))

;;; EWW
(defun my/split-and-eww (&optional url)
  "Split horizontally and open EWW in the new window. Prompts for URL if none is provided."
  (interactive)
  (let ((url (or url (read-string "URL: "))))
    (split-window-right)
    (other-window 1)
    (eww url)))



;; WINDOW- BORDER
(use-package selected-window-accent-mode
  :config (selected-window-accent-mode 1)
  :custom
  (selected-window-accent-fringe-thickness 10)
  (selected-window-accent-tab-height 3)
  (selected-window-accent-custom-color "#04D9FF")
  (selected-window-accent-mode-style 'tiling)
  (selected-window-accent-tab-accent t)
  (selected-window-accent-smart-borders t))

(set-frame-parameter (selected-frame) 'alpha 85)
(add-to-list 'default-frame-alist '(alpha 85))
