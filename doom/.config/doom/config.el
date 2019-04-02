;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; (when (not (display-graphic-p))
;;   (xterm-mouse-mode 1)
;;   (global-hl-line-mode 0)
;;   )

(setq frame-resize-pixelwise t)

(setq doom-theme 'doom-tomorrow-night
      doom-font (font-spec :family "Fantasque Sans Mono" :size 15)
      doom-serif-font (font-spec :family "Go Mono" :size 15)
      doom-variable-pitch-font (font-spec :family "Bitter" :size 16)
      doom-big-font (font-spec :family "Fantasque Sans Mono" :size 20)
      display-line-numbers-type nil)

;; Smoother scrolling with touchpad
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5) ((control))))
(setq mouse-wheel-progressive-speed nil)
(mouse-wheel-mode nil)
(mwheel-install)
(pixel-scroll-mode t)

;; dim non-editor windows
(solaire-global-mode +1)

(map! :leader
      :desc "M-x" "SPC" #'execute-extended-command
      (:prefix ("b" . "buffer")
        :desc "Kill buffer" "d" #'kill-this-buffer))

(setq deft-directory "~/sync/notes"
      deft-recursive t
      deft-default-extension "md"
      deft-use-filename-as-title t)
(with-eval-after-load 'evil
  (evil-set-initial-state 'deft-mode 'emacs))

(after! emojify
  (add-hook 'after-init-hook #'global-emojify-mode)
  )

(add-hook 'text-mode-hook 'mixed-pitch-mode)
(add-hook 'text-mode-hook 'olivetti-mode)

(add-hook 'yaml-mode-hook (lambda () (mixed-pitch-mode -1)))
(add-hook 'yaml-mode-hook (lambda () (olivetti-mode -1)))
(add-hook 'git-commit-mode-hook (lambda () (mixed-pitch-mode -1)))
(add-hook 'git-commit-mode-hook (lambda () (olivetti-mode -1)))

(add-hook 'js2-mode-hook 'eslintd-fix-mode)

;; hack
(setq gnutls-log-level 1)
