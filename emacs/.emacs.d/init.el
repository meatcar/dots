;;; package --- Init.el
;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:

;;; Commentary:

;;; Code:

;; fonts
(set-face-attribute 'default nil :height 120)

;;; Package repository & Setup
;; source: https://melpa.org/#/getting-started
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; Ensure use-package is present
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(eval-when-compile
  (require 'use-package))


;;; Base Config
;; custom file
(setq custom-file (locate-user-emacs-file "custom.el"))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

;; Fix Coding Errors
(set-language-environment "utf-8")
(prefer-coding-system 'utf-8)

;; Speed up, for Windows
(setq inhibit-compacting-font-caches t)

;; No backup files
(setq make-backup-files nil)
(setq backup-directory-alist (locate-user-emacs-file "backup"))

;; no toolbar
(tool-bar-mode -1)
;; no menu
(menu-bar-mode -1)
;; save history
(setq savehist-file (locate-user-emacs-file ".history"))
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
	search-ring
	regexp-search-ring))

;; Remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; show folders first in dired
(add-hook 'dired-load-hook
	  (lambda ()
	    (setq ls-lisp-dirs-first t)
	    (setq ls-lisp-use-insert-directory-program nil)
	    (require 'ls-lisp)
	    ))

;;;; Packages
;; Get PATH from Shell
(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

(use-package delight
  :ensure t)

;;; General: Easier keybindings
(use-package general
  :ensure t
  :demand t)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

;; doom-modeline: pretty modeline
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))
;; doom-themes: pretty themes
(use-package doom-themes
  :ensure t
  :after treemacs
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-treemacs-config)
  (doom-themes-org-config)
  )
;; solaire-mode: brighten active window
(use-package solaire-mode
  :ensure t
  :hook ((change-major-mode after-revert ediff-prepare-buffer) . turn-on-solaire-mode)
  :config
  (add-hook 'minibuffer-setup-hook #'solaire-mode-in-minibuffer)
  (solaire-mode-swap-bg))

(use-package smooth-scroll
  :ensure t
  :config
  (smooth-scroll-mode t)
  (setq mouse-wheel-progressive-speed nil)
  (setq mouse-wheel-follow-mouse 't))

;;; Show keybinding popups
(use-package which-key
  :ensure t
  :delight
  :config
  (which-key-mode))

;;; Evil: VIM Emulation
(use-package undo-tree
  :ensure t
  :delight)
(use-package evil
  :after (undo-tree)
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1 ))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; Swiper: nice ui/selections
(use-package ivy
  :ensure t
  :delight
  :config
  (ivy-mode 1)
  (setq ivy-initial-inputs-alist nil))
(use-package swiper
  :ensure t)
(use-package counsel
  :ensure t
  :after exec-path-from-shell
  :config
  ;; import fzf env
  (exec-path-from-shell-copy-env "FZF_DEFAULT_COMMAND")
  (with-eval-after-load 'evil-maps
    (define-key evil-normal-state-map (kbd "C-p") 'counsel-fzf))
  )

(use-package company
  :ensure t
  :config
  (global-company-mode t))

;;; Mu4e: Mail
(use-package mu4e
  :general
  (:keymaps '(mu4e-view-mode-map mu4e-headers-mode-map
				 mu4e-main-mode-map)
	    :states 'normal
	    "b" 'mu4e-headers-search-bookmark :wk "go to bookmarks"
	    "B" 'mu4e-headers-search-bookmark-edit :wk "edit a bookmark, then go to it")
  :config
  (setq mu4e-maildir "~/mail")

  ;; Set up default folders
  ;; TODO: OPTIONAL?
  (setq mu4e-sent-folder "/gmail/sent"
	mu4e-drafts-folder "/gmail/drafts"
	mu4e-refile-folder "/gmail/archive"
	mu4e-trash-folder "/gmail/trash"
	)

  ;; Mail directory shortcuts
  (setq mu4e-maildir-shortcuts
	'(("/gmail/inbox"    . ?g)
	  ("/fastmail/inbox" . ?f)
	  ("/zoho/inbox"     . ?z)
	  ))

  ;; set up mail accounts
  (setq mu4e-contexts
	`(
	  ,(make-mu4e-context
	    :name "gmail"
	    :match-func (lambda (msg)
			  (when msg
			    (string-match-p "^/gmail" (mu4e-message-field msg :maildir))))
	    :vars '((message-sendmail-extra-arguments . ("-a" "gmail"))
		    (mu4e-sent-folder       . "/gmail/Sent")
		    (mu4e-drafts-folder     . "/gmail/Drafts")
		    (mu4e-refile-folder     . "/gmail/Archive")
		    (mu4e-trash-folder      . "/gmail/Trash")
		    (user-mail-address      . "denys.pavlov@gmail.com")
		    (user-full-name         . "Denys Pavlov")
		    ))
	  ,(make-mu4e-context
	    :name "fastmail"
	    :match-func (lambda (msg)
			  (when msg
			    (string-match-p "^/fastmail" (mu4e-message-field msg :maildir))))
	    :vars '((message-sendmail-extra-arguments . ("-a" "fastmail"))
		    (mu4e-sent-folder       . "/fastmail/Sent")
		    (mu4e-drafts-folder     . "/fastmail/Drafts")
		    (mu4e-refile-folder     . "/fastmail/Archive")
		    (mu4e-trash-folder      . "/fastmail/Trash")
		    (user-mail-address      . "me@denys.me")
		    (user-full-name         . "Denys Pavlov")))
	  ,(make-mu4e-context
	    :name "zoho"
	    :match-func (lambda (msg)
			  (when msg
			    (string-match-p "^/zoho" (mu4e-message-field msg :maildir))))
	    :vars '((message-sendmail-extra-arguments . ("-a" "zoho"))
		    (mu4e-sent-folder       . "/zoho/Sent")
		    (mu4e-drafts-folder     . "/zoho/Drafts")
		    (mu4e-refile-folder     . "/zoho/Archive")
		    (mu4e-trash-folder      . "/zoho/Trash")
		    (user-mail-address      . "denys@dnka.ca")
		    (user-full-name         . "Denys" )))
	  ))


  ;; unset default behaviour
  (setq mu4e-get-mail-command "true")
  (setq mu4e-update-interval nil)
  (setq mu4e-index-cleanup nil)

  ;; speed up opening messages
  (setq mu4e-index-lazy-check t)
  ;; no signature
  (setq mu4e-compose-signature-auto-include nil)

  ;; show emails all pretty
  (setq mu4e-view-show-images t)
  (setq mu4e-use-fancy-chars t)
  ;; fix pretty icons
  (setq mu4e-headers-unread-mark '("?" . "◻") )

  ;; wrap long lines
  (setq mu4e-compose-format-flowed t)
  ;; hide the message buffer when exiting
  (setq message-kill-buffer-on-exit t)

  ;; set an html to text renderer
  ;; (setq mu4e-html-renderer 'w3m)
  ;; (setq mu4e-html2text-command "html2text -b 0 --mark-code --reference-links --no-wrap-links")
  (setq mu4e-html2text-command "w3m -dump -T text/html -o display_link_number=1")
  (setq mu4e-view-show-addresses t)

  ;; Sane multi-account defaults
  (setq mu4e-context-policy 'pick-first)
  (setq mu4e-compose-context-policy nil)

  ;; sending mail
  (setq send-mail-function 'sendmail-send-it )
  (setq mail-specify-envelope-from t)
  (setq mail-envelope-from 'header)
  (setq message-sendmail-envelope-from 'header)
  (setq message-send-mail-function 'message-send-mail-with-sendmail)
  (setq message-sendmail-f-is-evil 't)
  (setq sendmail-program "mymsmtp")

  ;; play nicely with mbsync, prevent UID errors
  (setq mu4e-change-filenames-when-moving t)
  ;; cut down on some noise
  (setq mu4e-headers-include-related nil)

  ;; use imagemagick, if available
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))


  ;; Some helper functions
  (defun mu4e-contextify (path)
    "Given a path, prepend only the context's maildir"
    (concat "/" (mu4e-context-name (mu4e-context-current)) "/" path))
  (defun mu4e-contextify-query (query)
    "Given a query, prepend only the context's maildir, and exclude sent/trash/spam"
    (concat query " AND "
	    "maildir:" (mu4e-contextify "*")
	    " AND NOT maildir:" (mu4e-contextify "Sent")
	    " AND NOT maildir:" (mu4e-contextify "Trash")
	    " AND NOT maildir:" (mu4e-contextify "Spam")
	    ))

  ;; add spam/junk mark
  (add-to-list 'mu4e-marks
	       '(spam
		 :char ("s" . "_")
		 :prompt "Spam"
		 :dyn-target (lambda (target msg) (mu4e-contextify "Spam"))
		 :action      (lambda (docid msg target)
				(mu4e~proc-move docid (mu4e~mark-check-target target) "-N"))))
  (mu4e~headers-defun-mark-for spam)
  (define-key mu4e-headers-mode-map (kbd "!") 'mu4e-headers-mark-for-spam)

  ;; bookmarks, visible in the main page for mu4e
  (setq mu4e-bookmarks
	(list
	 (make-mu4e-bookmark
	  :name "Inbox"
	  :query '(concat "maildir:" (mu4e-contextify "inbox"))
	  :key ?i
	  )
	 (make-mu4e-bookmark
	  :name "Archive"
	  :query '(concat "maildir:" (mu4e-contextify "Archive"))
	  :key ?a
	  )
	 (make-mu4e-bookmark
	  :name "Trash"
	  :query '(concat "maildir:" (mu4e-contextify "Trash"))
	  :key ?t
	  )
	 (make-mu4e-bookmark
	  :name "Sent"
	  :query '(concat "maildir:" (mu4e-contextify "Sent"))
	  :key ?s
	  )
	 (make-mu4e-bookmark
	  :name "Drafts"
	  :query '(concat "maildir:" (mu4e-contextify "Drafts"))
	  :key ?d
	  )
	 (make-mu4e-bookmark
	  :name "Unread messages"
	  :query '(mu4e-contextify-query "flag:unread AND NOT flag:trashed")
	  :key ?u
	  )
	 (make-mu4e-bookmark
	  :name "Today's messages"
	  :query '(mu4e-contextify-query "date:today..now")
	  :key ?1
	  )
	 (make-mu4e-bookmark
	  :name "Last 3 days"
	  :query '(mu4e-contextify-query "date:3d..now")
	  :key ?3
	  )
	 (make-mu4e-bookmark
	  :name "Last 7 days"
	  :query '(mu4e-contextify-query "date:7d..now")
	  :key ?7
	  )
	 (make-mu4e-bookmark
	  :name "With attachments"
	  :query '(mu4e-contextify-query "flag:attach")
	  :key ?A
	  )
	 ))

  (use-package mu4e-conversation
    :ensure t
    :config
    (global-mu4e-conversation-mode))
  )


(use-package all-the-icons
  :ensure t)
(use-package all-the-icons-dired
  :ensure t
  :after all-the-icons
  :config
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; projectile: easier project management
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1))

(use-package counsel-projectile
  :ensure t)

;; treemacs: a file browsing sidebar
(use-package treemacs
  :ensure t)
(use-package treemacs-evil
  :ensure t
  :after treemacs evil)
(use-package treemacs-projectile
  :ensure t
  :after treemacs projectile)

(use-package auth-source)
;; (use-package auth-source-pass
;;   :after auth-source
;;   :config (auth-source-pass-enable))

(use-package magit
  :ensure t)
(use-package evil-magit
  :after magit
  :ensure t)
(use-package forge
  :ensure t
  :after magit auth-source)

;; paradox: better package ui
(use-package paradox
  :ensure t
  :config (paradox-enable))

;; format-all
(use-package format-all
  :ensure t
  :init (format-all-mode))

;; evil-nerd-commenter
(use-package evil-nerd-commenter
  :ensure t
  :config (evilnc-default-hotkeys))

;; Flycheck
(use-package flycheck
  :ensure t
  :config (add-hook 'after-init-hook #'global-flycheck-mode))
(use-package flycheck-pos-tip
  :ensure t
  :after flycheck
  :config (with-eval-after-load 'flycheck (flycheck-pos-tip-mode)))

;; smartparens
(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t)
  (show-smartparens-global-mode t)
  )

;; org
(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))
(use-package org
  :config
  (setq org-directory "~/org")
  (setq org-agenda-files '("~/org"))
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
				   (org-agenda-files :maxlevel . 9)))))

;; Elixir
(use-package elixir-mode
  :ensure t
  :config
  (add-hook 'elixir-mode-hook 'flycheck-mode)
  (add-hook 'elixir-mode-hook #'smartparens-mode)
  )
(use-package alchemist
  :ensure t)
(use-package flycheck-mix
  :ensure t
  :config
  (add-hook 'elixir-mode-hook
	    (lambda () (add-hook 'before-save-hook 'elixir-format nil t)))
  (eval-after-load 'flycheck
    '(flycheck-mix-setup)))
(use-package flycheck-credo
  :ensure t
  :config
  (eval-after-load 'flycheck
    '(flycheck-credo-setup))
  )

(use-package cider
  :ensure t)
(use-package clojure-mode
  :ensure t)
(use-package flycheck-clojure
  :ensure t
  :config
  (eval-after-load 'flycheck '(flycheck-clojure-setup)))
(use-package 4clojure
  :ensure t)

;; Custom functions
(defun reload ()
  "Reload Emacs config."
  (interactive)
  (load-file user-init-file))

(evil-ex-define-cmd "W[rite]" 'evil-write)
(evil-ex-define-cmd "bd" 'kill-this-buffer)

;; Custom keybinds
(general-define-key
 :states '(normal)
 "`" '(dired-jump :wk "open dired"))

(general-define-key
 :states '(normal)
 :keymaps 'dired-mode-map
 "`" '(quit-window :wk "close dired"))

(general-create-definer space-leader-def
  :prefix "SPC")

;; ** Global Keybindings
(space-leader-def
  :states '(normal)
  :keymaps 'override
  "h" '(:ignore t :wk "help")
  "h f" '(counsel-describe-function :wk "functions")
  "h v" '(counsel-describe-variable :wk "variables")
  "h k" '(describe-key :wk "keys")
  "h m" '(describe-minor-mode-from-symbol :wk "minor-mode")
  "h M" '(describe-mode :wk "major-mode")

  ":" '(counsel-M-x :wk "M-x")
  "SPC" '(counsel-M-x :wk "M-x")

  "b" '(:ignore t :wk "buffers")
  "b b" '(counsel-ibuffer :wk "buffers")
  "b d" '(kill-this-buffer :wk "delete current")
  "b n" '(switch-to-next-buffer :wk "next")
  "b p" '(switch-to-prev-buffer :wk "prev")

  "f" '(:ignore t :wk "files")
  "f r" '(counsel-recentf :wk "recent files")
  "f f" '(counsel-fzf :wk "files")
  "f s" '(counsel-rg :wk "search")

  "p" '(:ignore t :wk "projectile")
  "p p" '(counsel-projectile-switch-project :wk "switch to project")
  "p f" '(counsel-projectile-find-file :wk "files")
  "p b" '(counsel-projectile-switch-to-buffer :wk "buffers")
  "p s" '(counsel-projectile-rg :wk "search")

  "g" '(:ignore t :wk "git")
  "g s" '(magit-status :wk "git status")

  "x" '(:ignore t :wk "text")

  ;; apps
  "a" '(:ignore t :wk "apps")
  "a m" '(mu4e :wk "email")
  "a t" '(treemacs :wk "file-tree")
  "a p" '(list-packages :wk "packages")

  "m" '(:ignore t :wk "mode")

  "t" '(:ignore t :wk "toggle")
  "t t" '(counsel-load-theme :wk "theme")
  )

(space-leader-def
  :states '(visual normal)

  "x c" '(evilnc-comment-or-uncomment-lines :wk "toggle comment")
  )
(space-leader-def
  :states '(visual normal)
  :keymaps 'elixir-mode-map
  "me" '(:ignore t :wk "eval")
  "mel" 'alchemist-eval-current-line
  "meL" 'alchemist-eval-print-current-line
  "mer" 'alchemist-eval-region
  "meR" 'alchemist-eval-print-region
  "meb" 'alchemist-eval-buffer
  "meB" 'alchemist-eval-print-buffer
  "mej" 'alchemist-eval-quoted-current-line
  "meJ" 'alchemist-eval-print-quoted-current-line
  "meu" 'alchemist-eval-quoted-region
  "meU" 'alchemist-eval-print-quoted-region
  "mev" 'alchemist-eval-quoted-buffer
  "meV" 'alchemist-eval-print-quoted-buffer

  "mp" '(:ignore t :wk "project")
  "mpt" 'alchemist-project-find-test
  "mgt" 'alchemist-project-toggle-file-and-tests
  "mgT" 'alchemist-project-toggle-file-and-tests-other-window

  "mh" '(:ignore t :wk "help")
  "mh:" 'alchemist-help
  "mhH" 'alchemist-help-history
  "mhh" 'alchemist-help-search-at-point
  "mhr" 'alchemist-help-search-marked-region

  "mm" '(:ignore t :wk "mix")
  "mmr" 'alchemist-mix
  "mmm" 'alchemist-mix-rerun-last-task
  "mmc" 'alchemist-mix-compile
  "mmx" 'alchemist-mix-run
  "mmh" 'alchemist-mix-help
  "mmt" 'alchemist-mix-test

  "m'"  'alchemist-iex-run

  "ms" '(:ignore t :wk "iex")
  "msc" 'alchemist-iex-compile-this-buffer
  "msi" 'alchemist-iex-run
  "msI" 'alchemist-iex-project-run
  "msl" 'alchemist-iex-send-current-line
  "msL" 'alchemist-iex-send-current-line-and-go
  "msm" 'alchemist-iex-reload-module
  "msr" 'alchemist-iex-send-region
  "msR" 'alchemist-iex-send-region-and-go

  "mt" '(:ignore t :wk "test")
  "mtt" 'alchemist-mix-test
  "mtb" 'alchemist-mix-test-this-buffer
  "mtf" 'alchemist-test-file
  "mtn" 'alchemist-test-jump-to-next-test
  "mtp" 'alchemist-test-jump-to-previous-test
  "mtr" 'alchemist-mix-rerun-last-test

  "mx" '(:ignore t :wk "execute")
  "mxb" 'alchemist-execute-this-buffer
  "mxf" 'alchemist-execute-file
  "mx:" 'alchemist-execute

  "mc" '(:ignore t :wk "compile")
  "mcb" 'alchemist-compile-this-buffer
  "mcf" 'alchemist-compile-file
  "mc:" 'alchemist-compile

  "m," 'alchemist-goto-jump-back)


(provide 'init)
;;; init.el ends here
