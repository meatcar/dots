(defun meatcar/mu4e-contextify (path)
  "Given a path, prepend only the context's maildir"
  (concat "/" (mu4e-context-name (mu4e-context-current)) "/" path))

(defun meatcar/mu4e-contextify-query (query)
  "Given a path, prepend only the context's maildir"
  (concat query " AND "
          "maildir:" (meatcar/mu4e-contextify "*")
          " AND NOT maildir:" (meatcar/mu4e-contextify "Sent")
          " AND NOT maildir:" (meatcar/mu4e-contextify "Trash")
          " AND NOT maildir:" (meatcar/mu4e-contextify "Spam")
          ))

(setq mu4e-enable-notiications t)
(with-eval-after-load 'mu4e-alert
  (mu4e-alert-set-default-style 'libnotify))

;; Fix Coding Errors
(set-language-environment "utf-8") 
(prefer-coding-system 'utf-8) 

  ;;; Set up some common mu4e variables
(setq mu4e-maildir "~/mail"
      mu4e-get-mail-command "true"
      mu4e-update-interval 15
      mu4e-index-cleanup nil
      mu4e-index-lazy-check t
      mu4e-compose-signature-auto-include nil
      mu4e-view-show-images t
      mu4e-use-fancy-chars t
      mu4e-compose-format-flowed t
      message-kill-buffer-on-exit t
      ;; mu4e-html-renderer 'w3m
      ;; mu4e-html2text-command "html2text -b 0 --mark-code --reference-links --no-wrap-links"
      mu4e-html2text-command "w3m -dump -T text/html -o display_link_number=1"
      mu4e-view-show-addresses t
      mu4e-context-policy 'pick-first
      mu4e-compose-context-policy nil

      send-mail-function 'sendmail-send-it 
      mail-specify-envelope-from t
      mail-envelope-from 'header
      message-sendmail-envelope-from 'header
      message-send-mail-function 'message-send-mail-with-sendmail
      message-sendmail-f-is-evil 't
      sendmail-program "mymsmtp"

      mu4e-change-filenames-when-moving t ;play nicely with mbsync, prevent UID errors
      mu4e-headers-include-related nil ;cut down on some noise

      mu4e-headers-unread-mark '("?" . "◻") ;fix pretty icons
      )

;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

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

(defun meatcar-mu4e/keybinds ()
  (local-set-key (kbd "g") #'mu4e-headers-search-bookmark)
  (local-set-key (kbd "G") #'mu4e-headers-search-bookmark-edit))

(with-eval-after-load 'mu4e
  (evilified-state-evilify-map mu4e-main-mode-map
    :mode mu4e-main-mode
    :bindings
    (kbd "g z") 'mu4e-headers-search-bookmark
    (kbd "g Z") 'mu4e-headers-search-bookmark-edit
    )
  (add-to-list 'mu4e-marks
               '(spam
                 :char ("s" . "_")
                 :prompt "Spam"
                 :dyn-target (lambda (target msg) (meatcar/mu4e-contextify "Spam"))
                 :action      (lambda (docid msg target)
                                (mu4e~proc-move docid (mu4e~mark-check-target target) "-N"))))
  (mu4e~headers-defun-mark-for spam)
  (define-key mu4e-headers-mode-map (kbd "!") 'mu4e-headers-mark-for-spam)

  (setq mu4e-bookmarks
        (list
         (make-mu4e-bookmark
          :name "Inbox"
          :query '(concat "maildir:" (meatcar/mu4e-contextify "inbox"))
          :key ?i
          )
         (make-mu4e-bookmark
          :name "Archive"
          :query '(concat "maildir:" (meatcar/mu4e-contextify "Archive"))
          :key ?a
          )
         (make-mu4e-bookmark
          :name "Trash"
          :query '(concat "maildir:" (meatcar/mu4e-contextify "Trash"))
          :key ?t
          )
         (make-mu4e-bookmark
          :name "Sent"
          :query '(concat "maildir:" (meatcar/mu4e-contextify "Sent"))
          :key ?s
          )
         (make-mu4e-bookmark
          :name "Drafts"
          :query '(concat "maildir:" (meatcar/mu4e-contextify "Drafts"))
          :key ?d
          )
         (make-mu4e-bookmark
          :name "Unread messages"
          :query '(meatcar/mu4e-contextify-query "flag:unread AND NOT flag:trashed")
          :key ?u
          )
         (make-mu4e-bookmark
          :name "Today's messages"
          :query '(meatcar/mu4e-contextify-query "date:today..now")
          :key ?1
          )
         (make-mu4e-bookmark
          :name "Last 3 days"
          :query '(meatcar/mu4e-contextify-query "date:3d..now")
          :key ?3
          )
         (make-mu4e-bookmark
          :name "Last 7 days"
          :query '(meatcar/mu4e-contextify-query "date:7d..now")
          :key ?7
          )
         (make-mu4e-bookmark
          :name "With attachments"
          :query '(meatcar/mu4e-contextify-query "flag:attach")
          :key ?A
          )
         ))

  (setq mu4e-contexts
        `(
          ,(make-mu4e-context
            :name "gmail"
            ;; :enter-func (lambda () (mu4e/mail-account-reset))
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
            ;; :enter-func (lambda () (mu4e/mail-account-reset))
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
            ;; :enter-func (lambda () (mu4e/mail-account-reset))
            :match-func (lambda (msg)
                          (when msg
                            (string-match-p "^/zoho" (mu4e-message-field msg :maildir))))
            :vars '((message-sendmail-extra-arguments . ("-a" "zoho"))
                    (mu4e-sent-folder       . "/zoho/Sent")
                    (mu4e-drafts-folder     . "/zoho/Drafts")
                    (mu4e-refile-folder     . "/zoho/Archive")
                    (mu4e-trash-folder      . "/zoho/Trash")
                    (user-mail-address      . "denys@techhappy.ca")
                    (user-full-name         . "Denys" )))
          ))
  )

