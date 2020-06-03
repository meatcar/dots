;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;; Code:
;; make emacs useable in terminal (for the rare occasion)
(when (not (display-graphic-p))
  (xterm-mouse-mode 1)
  (global-hl-line-mode 0))

(defconst IS-WINDOWS-WSL
  (when (string-match-p "microsoft" operating-system-release) t)
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

(defun me/dark-theme-p ()
  "Should we show a dark theme?"
  (cond
   ((or IS-WINDOWS IS-WINDOWS-WSL) (me/windows-dark-theme-p))
   (:else (me/env-dark-theme-p))))

(defun me/get-system-theme ()
  "Return either 'light or 'dark, depending on the system settings."
  (cond
   ((or IS-WINDOWS IS-WINDOWS-WSL)
    (if (me/windows-dark-theme-p) 'dark 'light))
   (:else (if (me/dark-theme-p) 'dark 'light))))

(defun me/get-theme (&optional color)
  "Get the theme according to system env.

  Force a selection with COLOR, either 'light or 'dark"
  (if color color
    (pcase (me/get-system-theme)
      ('light me/doom-light-theme)
      ('dark me/doom-dark-theme))))

(defun me/set-theme (&optional color)
  "Set the theme.

  Force a selection with COLOR, either 'light or 'dark"
  (interactive)
  (load-theme (me/get-theme color) t))

(defvar me/doom-light-theme 'doom-one-light
  "Light theme")
(defvar me/doom-dark-theme 'doom-dracula
  "Dark theme")

(setq magit-delta-default-dark-theme "Dracula"
      magit-delta-default-light-theme "OneHalfLight")

(setq doom-theme (me/get-theme)
      doom-font (font-spec :family "Go Mono" :size 12)
      doom-serif-font (font-spec :family "Go Mono")
      doom-variable-pitch-font (font-spec :family "Bitter" :size 14)
      doom-big-font (font-spec :family "Go Mono" :size 20))

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

(setq mixed-pitch-set-height t)
(after! mixed-pitch
  (add-to-list 'mixed-pitch-fixed-pitch-faces 'org-done)
  (add-to-list 'mixed-pitch-fixed-pitch-faces 'org-ellipsis))
(add-hook 'text-mode-hook        #'mixed-pitch-mode)
(add-hook 'yaml-mode-hook        (lambda () (mixed-pitch-mode -1)))
(add-hook 'git-commit-mode-hook  (lambda () (mixed-pitch-mode -1)))
(add-hook 'xml-mode-hook         (lambda () (mixed-pitch-mode -1)))

;; (add-hook 'after-init-hook #'global-emojify-mode)

(setq flycheck-disabled-checkers '(emacs-lisp-checkdoc))

(add-hook 'magit-mode-hook #'magit-delta-mode)

(add-hook 'term-mode-hook #'eterm-256color-mode)

(add-hook 'js2-mode-hook #'add-node-modules-path)
(add-hook 'js2-mode-hook #'eslintd-fix-mode)

(add-hook 'nix-mode-hook #'nixpkgs-fmt-on-save-mode)
(add-hook 'shell-mode-hook #'pretty-sha-path-mode)
(add-hook 'dired-mode-hook #'pretty-sha-path-mode)

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
        org-fontify-quote-and-verse-blocks t
        ;; clock
        org-clock-persist t
        org-clock-in-resume t
        org-clock-out-remove-zero-time-clocks t
        org-clock-out-when-done t
        org-clock-report-include-clocking-task t
        org-clock-auto-clock-resolution (quote when-no-clock-is-running))

  (org-persistenct-insinuate)

  (org-projectile-per-project)
  (setq org-projectile-per-project-filepath "todo.org")
  (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
