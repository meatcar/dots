;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; (when (not (display-graphic-p))
;;   (xterm-mouse-mode 1)
;;   (global-hl-line-mode 0)
;;   )

(setq frame-resize-pixelwise t)

(setq doom-theme 'doom-dracula
      doom-font (font-spec :family "Go Mono" :size 14)
      doom-big-font (font-spec :family "Go Mono" :size 20)
      display-line-numbers-type nil)

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
