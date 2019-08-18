;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; (when (not (display-graphic-p))
;;   (xterm-mouse-mode 1)
;;   (global-hl-line-mode 0)
;;   )

;; run with fat garbage heap
(setq doom-gc-cons-threshold #x20000000) ; 500mb

(setq frame-resize-pixelwise t)

(defvar me/windows-wsl?
  (string-match "Microsoft" operating-system-release)
  "Is Windows Subsystem for Linux?")
(defvar me/windows?
  (eq system-type 'windows-nt)
  "Is Windows?")

;; Theme
(defun me/windows-apps-use-light-theme ()
  "Value of AppsUseLightTheme in Registry."
  (string-to-number
   (shell-command-to-string "powershell.exe '(Get-ItemProperty -Path HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize).AppsUseLightTheme'")))

(defun me/windows-dark-theme-p ()
  "Is Windows running a dark theme."
  (zerop (me/windows-apps-use-light-theme)))

(defun me/env-dark-theme-p ()
  "Is DARK_THEME env var set."
  t) ;TODO

(defun me/dark-theme-p (&optional dark)
  "Should we show a dark theme? If arg dark is present and 'dark, return t, nil
  otherwise. If arg dark is absent, return the system theme setting."
  (cond
   (dark (eq dark 'dark))
   ((or me/windows-wsl? me/windows?) (me/windows-dark-theme-p))
   (:else (me/env-dark-theme-p))))

(defun me/get-theme (&optional dark)
  "Get the theme according to system env."
  (if (me/dark-theme-p dark) 'doom-dracula 'doom-one-light))

(defun me/set-theme (&optional dark)
  "Set the theme."
  (interactive)
  (load-theme (me/get-theme dark) t))

;; Fonts
(cond
 (me/windows-wsl?
  (setq doom-font (font-spec :family "Iosevka SS07" :size 14)
        doom-serif-font (font-spec :family "Go Mono")
        doom-variable-pitch-font (font-spec :family "DejaVu Sans")
        doom-big-font (font-spec :family "Iosevka SS07" :size 18)))
 (:else
  (setq doom-font (font-spec :family "Dina" :size 12)
        doom-serif-font (font-spec :family "Go Mono")
        doom-variable-pitch-font (font-spec :family "SF Pro Text" :size 14)
        doom-big-font (font-spec :family "Iosevka SS07" :size 20))))

(set-face-attribute 'variable-pitch nil :font doom-variable-pitch-font)
;; custom iosevka with the ligatures in a custom use area
;; source: https://github.com/hlissner/doom-emacs/issues/695#issuecomment-402446573
;; (set-fontset-font t '(#Xe100 . #Xe16f) "Iosevka")

(setq
 doom-theme (me/get-theme)
 display-line-numbers-type nil)

;; Smoother scrolling with touchpad
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5) ((control))))
(setq mouse-wheel-progressive-speed nil)
(mouse-wheel-mode nil)
(mwheel-install)
(pixel-scroll-mode t)
;; fast scroll
(fast-scroll-config)
(fast-scroll-advice-scroll-functions)

;; don't dim non-editor windows
(solaire-global-mode -1)

(map! :leader
      (:prefix ("b" . "buffer")
        :desc "Kill buffer" "d" #'kill-this-buffer)
      (:prefix ("t" . "toggle")
        :desc "Theme" "t" #'load-theme))

(setq projectile-project-search-path '("~/git"))

(setq deft-directory "~/Sync/notes"
      deft-recursive t
      deft-default-extension "md"
      deft-use-filename-as-title t)
(with-eval-after-load 'evil
  (evil-set-initial-state 'deft-mode 'emacs))

(add-hook 'text-mode-hook 'mixed-pitch-mode)
(add-hook 'yaml-mode-hook (lambda () (mixed-pitch-mode -1)))
(add-hook 'git-commit-mode-hook (lambda () (mixed-pitch-mode -1)))

;; window margins
(setq-default left-margin-width 2 right-margin-width 2) ; Define new widths.
(set-window-buffer nil (current-buffer)) ; Use them now.
(set-frame-parameter (selected-frame) 'internal-border-width 10)

(after! emojify (add-hook 'after-init-hook #'global-emojify-mode))

(add-hook 'js2-mode-hook #'add-node-modules-path)
(add-hook 'js2-mode-hook #'eslintd-fix-mode)

(setq +org-capture-todo-file (concat org-directory "aardvark.org"))
(after! org
  (setq org-capture-templates '(("p" "Protocol" entry (file+headline +org-capture-todo-file "Inbox")
                                  "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
                                 ("L" "Protocol Link" entry (file+headline +org-capture-todo-file "Inbox")
                                  "* %? [[%:link][%:description]] \nCaptured On: %U")))

  (setq org-startup-indented t
        org-bullets-bullet-list '(" ") ;; no bullets, needs org-bullets package
        org-ellipsis "⤵" ;; folding symbol
        org-pretty-entities t
        org-hide-emphasis-markers t
        ;; show actually italicized text instead of /italicized text/
        org-agenda-block-separator ""
        org-startup-truncated nil
        org-fontify-quote-and-verse-blocks t)


  (require 'org-projectile)
  (org-projectile-per-project)
  (setq org-projectile-per-project-filepath "todo.org")
  (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files))))

;; Utility functions
(defun what-face (pos)
    (interactive "d")
        (let ((face (or (get-char-property (point) 'read-face-name)
            (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))
