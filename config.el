;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional. (setq user-full-name "John Doe" user-mail-address "john@doe.com")

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
;; (add-to-list 'default-frame-alist '(alpha 85))
(setq doom-theme 'doom-homage-black)
(setq fancy-splash-image "~/.doom.d/doom-splash-2.jpg")

;; SPLASH SCREEN QUOTE
(defvar my/splash-quotes
  '("OMNIA ROMAE VENALIA SUNT"))

(defun my/random-splash-quote ()
  (let* ((quote (nth (random (length my/splash-quotes)) my/splash-quotes))
         (scaled-width (ceiling (* (length quote) 1.4)))
         (padding (make-string (max 0 (/ (- +doom-dashboard--width scaled-width) 2)) ?\s)))
    (insert "\n")
    (insert padding)
    (insert (propertize quote
                        'face '(:inherit font-lock-comment-face :slant italic :height 1.4)))
    (insert "\n\n")))

(setq +doom-dashboard-functions
      '(doom-dashboard-widget-banner
        my/random-splash-quote
        doom-dashboard-widget-shortmenu
        doom-dashboard-widget-loaded))

;; FONTS
(setq doom-font (font-spec :family "Iosevka Nerd Font Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 13)
      doom-symbol-font (font-spec :family "all-the-icons")
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
      :desc "Dired buffer"
      "d" #'dired)


(map! :leader
      :desc "Lookup Fast"
      "o e" #'my/split-and-eww)

(map! :leader
      :desc "Rename symbol"
      "r" #'lsp-rename)
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
  (setq org-alert-interval 300 ; Check every 5 minutes
        org-alert-notification-title "Org Reminder"
        org-alert-notify-cutoff 10 ; Show alerts for tasks due in 10 minutes
        org-alert-notify-after-event-cutoff 10 ; Keep showing for 10 mins after
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





;; ============================================================
;; LSP QUALITY OF LIFE - TypeScript / Web
;; ============================================================
(after! lsp-mode
  ;; Performance tuning
  (setq lsp-idle-delay 0.5
        lsp-log-io nil
        lsp-completion-provider :capf
        lsp-headerline-breadcrumb-enable t
        lsp-enable-symbol-highlighting t
        lsp-enable-on-type-formatting t
        lsp-signature-auto-activate t
        lsp-signature-render-documentation t
        lsp-modeline-code-actions-enable t
        lsp-modeline-diagnostics-enable t
        lsp-lens-enable t))

(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-show-with-cursor t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-delay 0.2
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-actions t
        lsp-ui-peek-enable t))

;; TypeScript specific
(after! typescript-mode
  (setq typescript-indent-level 2))

;; Enable company and LSP for tree-sitter TypeScript modes
(add-hook 'typescript-tsx-mode-hook #'company-mode)
(add-hook 'typescript-tsx-mode-hook #'lsp!)
(add-hook 'typescript-ts-mode-hook #'company-mode)
(add-hook 'typescript-ts-mode-hook #'lsp!)

;; Use typescript-language-server
(after! lsp-mode
  (setq lsp-clients-typescript-prefer-use-project-ts-server t))

;; Web-mode settings for JSX/TSX
(after! web-mode
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-auto-quoting nil))

;; ============================================================
;; LSP QUALITY OF LIFE - Rust
;; ============================================================
(after! rustic
  (setq rustic-format-on-save t
        rustic-lsp-client 'lsp-mode))

(after! lsp-rust
  (setq lsp-rust-analyzer-cargo-watch-command "clippy"
        lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial"
        lsp-rust-analyzer-display-chaining-hints t
        lsp-rust-analyzer-display-closure-return-type-hints t
        lsp-rust-analyzer-display-parameter-hints t
        lsp-rust-analyzer-proc-macro-enable t
        lsp-rust-analyzer-cargo-load-out-dirs-from-check t
        lsp-rust-analyzer-inlay-hints-mode t))

;; ============================================================
;; FILE / DIRECTORY CREATION KEYBINDS
;; ============================================================
(defun my/create-file ()
  "Create a new file, prompting for the path."
  (interactive)
  (let ((file (read-file-name "Create file: ")))
    (when (and file (not (string-empty-p file)))
      (make-directory (file-name-directory file) t)
      (find-file file))))

(defun my/create-directory ()
  "Create a new directory, prompting for the path."
  (interactive)
  (let ((dir (read-directory-name "Create directory: ")))
    (when (and dir (not (string-empty-p dir)))
      (make-directory dir t)
      (dired dir))))

(map! :leader
      (:prefix ("f" . "files")
       :desc "Create new file" "n" #'my/create-file
       :desc "Create new directory" "N" #'my/create-directory))

;; ============================================================
;; CLAUDE CODE
;; ============================================================
(use-package! claude-code-ide
  :commands (claude-code-ide-start)
  :config
  (setq claude-code-ide-auto-accept nil))

(map! :leader
      (:prefix ("s" . "search")
       :desc "Claude Code" "c" #'claude-code-ide))
