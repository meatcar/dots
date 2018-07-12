;;; packages.el --- org-capture layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Denys Pavlov <meatcar@bronn>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `org-capture-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `org-capture/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `org-capture/pre-init-PACKAGE' and/or
;;   `org-capture/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst org-capture-packages
  '((org-protocol :location built-in))
  "The list of Lisp packages required by the org-capture layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun org-capture/init-org-protocol ()
   (use-package org-protocol
     :defer t
     :init
     (with-eval-after-load 'org
       (require 'org-protocol)
                                        ; from https://github.com/sprig/org-capture-extension
       (defun transform-square-brackets-to-round-ones(string-to-transform)
         "Transforms [ into ( and ] into ), other chars left unchanged."
         (concat 
          (mapcar
           (lambda (c)
             (cond ((equal c ?\[) ?\()
                   ((equal c ?\]) ?\))
                   (t c)))
           string-to-transform))
         )

       (if (not (boundp 'org-capture-templates)) (setq org-capture-templates '()))

                                        ;,(concat org-directory "/notes.org")
       (with-eval-after-load 'org
         (add-to-list 
          'org-capture-templates
          '("p" "protocol" entry (file+headline "" "Inbox")
            "* %^{title}\nsource: %u, %c\n#+begin_quote\n%i\n#+end_quote\n\n\n%?"))
         (add-to-list 
          'org-capture-templates
          '("L" "Protocol Link" entry (file+headline "" "Inbox")
            "* %?[[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]]\n %(progn (setq kk/delete-frame-after-capture 2) nil)")
          ))

       (defvar kk/delete-frame-after-capture 0 "Whether to delete the last frame after the current capture")

       (defun kk/delete-frame-if-neccessary (&rest r)
         (cond
          ((= kk/delete-frame-after-capture 0) nil)
          ((> kk/delete-frame-after-capture 1)
           (setq kk/delete-frame-after-capture (- kk/delete-frame-after-capture 1)))
          (t
           (setq kk/delete-frame-after-capture 0)
           (delete-frame))))

       (advice-add 'org-capture-finalize :after 'kk/delete-frame-if-neccessary)
       (advice-add 'org-capture-kill :after 'kk/delete-frame-if-neccessary)
       (advice-add 'org-capture-refile :after 'kk/delete-frame-if-neccessary)

       (defadvice org-switch-to-buffer-other-window
           (after supress-window-splitting activate)
         "Delete the extra window if we're in a capture frame"
         (if (equal "capture" (frame-parameter nil 'name))
             (delete-other-windows)))

       ;; (defadvice org-capture-finalize
       ;;     (after delete-capture-frame activate)
       ;;   "Advise capture-finalize to close the frame"
       ;;   (when (and (equal "capture" (frame-parameter nil 'name))
       ;;              (not (eq this-command 'org-capture-refile)))
       ;;     (delete-frame)))

       ;; (defadvice org-capture-refile
       ;;     (after delete-capture-frame activate)
       ;;   "Advise org-refile to close the frame"
       ;;   (delete-frame))

       ;; (defun activate-capture-frame ()
       ;;   (select-frame-by-name "capture")
       ;;   (delete-other-windows))

       )))
