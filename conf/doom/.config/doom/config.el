;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; make emacs useable in terminal (for the rare occasion)
(when (not (display-graphic-p))
  (xterm-mouse-mode 1)
  (global-hl-line-mode 0))

(defconst IS-WINDOWS-WSL
  (string-match "Microsoft" operating-system-release)
  "Is Windows Subsystem for Linux?")

;; Add padding inside buffer windows
(setq-default left-margin-width 2
              right-margin-width 2)
(set-window-buffer nil (current-buffer)) ; Use them now.
;; Add padding inside frames (windows)
(add-to-list 'default-frame-alist '(internal-border-width . 10))
(set-frame-parameter nil 'internal-border-width 10) ;; Use them now

;; Get dark/light theme preference from system.
(defun me/windows-apps-use-light-theme ()
  "Value of AppsUseLightTheme in Registry."
  (string-to-number
   (shell-command-to-string "powershell.exe '(Get-ItemProperty -Path HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize).AppsUseLightTheme'")))

(defun me/windows-dark-theme-p ()
  "Is Windows running a dark theme."
  (zerop (me/windows-apps-use-light-theme)))

(defun me/env-dark-theme-p ()
  "Is DARK_THEME env var set."
  (getenv "DARK_THEME")) ;TODO

(defun me/dark-theme-p (&optional dark)
  "Should we show a dark theme? If arg dark is present and 'dark, return t, nil
  otherwise. If arg dark is absent, return the system theme setting."
  (cond
   (dark (eq dark 'dark))
   ((or IS-WINDOWS IS-WINDOWS-WSL) (me/windows-dark-theme-p))
   (:else (me/env-dark-theme-p))))

(defun me/get-theme (&optional dark)
  "Get the theme according to system env."
  (cond
   ((me/dark-theme-p dark) 'doom-dracula)
   (:else                  'doom-one-light)))

(defun me/set-theme (&optional dark)
  "Set the theme."
  (interactive)
  (load-theme (me/get-theme dark) t))

(setq doom-theme (me/get-theme)
      doom-font (font-spec :family "Iosevka SS07" :size 14)
      doom-serif-font (font-spec :family "Go Mono")
      doom-variable-pitch-font (font-spec :family (if IS-WINDOWS-WSL "Inter" "Bitter") :size 15)
      doom-big-font (font-spec :family "Iosevka SS07" :size 20))

(setq custom-file (concat doom-private-dir "custom.el")
      display-line-numbers-type nil
      frame-resize-pixelwise t     ; resize frame by pixel, not by character box
      mouse-wheel-scroll-amount '(1 ((shift) . 5) ((control))) ; Smoother scrolling with touchpad
      scroll-margin 3)


;; fix variable-pitch font not getting set
(set-face-attribute 'variable-pitch nil :font doom-variable-pitch-font)

;; VSCode/Atom/Sublime-ish keymaps
(map!
 :n "C-p" #'projectile-find-file
 :n "C-S-p" #'execute-extended-command
 :n "C-j" #'evil-window-down
 :n "C-k" #'evil-window-up
 :n "C-h" #'evil-window-left
 :n "C-l" #'evil-window-right)

(map! :leader
      :desc "M-x" "SPC" #'execute-extended-command ; spacemacs-ish
      (:prefix ("b" . "buffer")
        :desc "Kill buffer" "d" #'kill-this-buffer)
      (:prefix ("t" . "toggle")
        :desc "Colortheme" "c" #'load-theme))

(setq projectile-project-search-path '("~/git"))

(setq deft-directory "~/Sync/notes"
      deft-recursive t
      deft-default-extension "md"
      deft-use-filename-as-title t)
(with-eval-after-load 'evil
  (evil-set-initial-state 'deft-mode 'emacs))

(after! mixed-pitch
  (add-to-list 'mixed-pitch-fixed-pitch-faces 'org-done)
  (add-to-list 'mixed-pitch-fixed-pitch-faces 'org-ellipsis))
(add-hook 'text-mode-hook        'mixed-pitch-mode)
(add-hook 'yaml-mode-hook        (lambda () (mixed-pitch-mode -1)))
(add-hook 'git-commit-mode-hook  (lambda () (mixed-pitch-mode -1)))
(add-hook 'xml-mode-hook         (lambda () (mixed-pitch-mode -1)))

;; (add-hook 'after-init-hook #'global-emojify-mode)

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
        org-ellipsis "..."              ;; folding symbol
        org-pretty-entities t
        org-hide-emphasis-markers t
        ;; show actually italicized text instead of /italicized text/
        org-agenda-block-separator ""
        org-startup-truncated nil
        org-fontify-quote-and-verse-blocks t)

  (org-projectile-per-project)
  (setq org-projectile-per-project-filepath "todo.org")
  (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files))))
