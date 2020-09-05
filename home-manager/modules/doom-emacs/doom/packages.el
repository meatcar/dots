;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

;; themes
(package! poet-theme)
(package! soothe-theme)
(package! sublime-themes)
(package! base16-theme)
(package! berrys-theme)
(package! moe-theme)

(package! emojify)
(package! olivetti)
(package! org-projectile)

(package! nix-mode)
(package! nixpkgs-fmt)
(package! pretty-sha-path)

(package! xterm-color)
(package! eterm-256color)
(package! magit-delta :recipe (:host github :repo "dandavison/magit-delta"))

(package! forge)

(package! add-node-modules-path)
(package! fast-scroll :recipe (:host github :repo "ahungry/fast-scroll"))
(package! org-projectile)
(package! mixed-pitch :recipe (:host gitlab :repo "jabranham/mixed-pitch"))
(package! org-superstar)
