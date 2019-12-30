;;; packages.el --- better-pass layer packages file for Spacemacs.
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
;; added to `better-pass-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `better-pass/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `better-pass/pre-init-PACKAGE' and/or
;;   `better-pass/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst better-pass-packages
  '(
    password-store
    pass
    helm-pass
    auth-source-pass
    )
  "The list of Lisp packages required by the better-pass layer.

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

(defun better-pass/init-password-store ()
  (use-package password-store
    :defer t
    :init))

(defun better-pass/init-pass ()
  (use-package pass
    :defer t
    :init))

(defun better-pass/init-helm-pass ()
  (use-package helm-pass
    :defer t
    :init))

(defun better-pass/init-auth-source-pass ()
  (use-package auth-source-pass
    :defer t
    :init (auth-source-pass-enable)))

;;; packages.el ends here
