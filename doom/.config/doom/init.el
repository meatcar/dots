;;; init.el -*- lexical-binding: t; -*-

;; Copy this file to ~/.doom.d/init.el or ~/.config/doom/init.el ('doom install'
;; will do this for you). The `doom!' block below controls what modules are
;; enabled and in what order they will be loaded. Remember to run 'doom refresh'
;; after modifying it.
;;
;; More information about these modules (and what flags they support) can be
;; found in modules/README.org.

(doom! :input
       ;;chinese
       ;;japanese

       :completion
       company              ; the ultimate code completion backend
       ;; helm              ; the *other* search engine for love and life
       ;; ido               ; the other *other* search engine...
       (ivy +fuzzy)         ; a search engine for love and life

       :ui
       deft                 ; notational velocity for Emacs
       doom                 ; what makes DOOM look the way it does
       doom-dashboard       ; a nifty splash screen for Emacs
       doom-quit            ; DOOM quit-message prompts when you quit Emacs
       ;;fill-column        ; a `fill-column' indicator
       hl-todo              ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       ;;hydra
       ;;indent-guides      ; highlighted indent columns
       modeline             ; snazzy, Atom-inspired modeline, plus API
       nav-flash            ; blink the current line after jumping
       ;;neotree            ; a project drawer, like NERDTree for vim
       ophints              ; highlight the region an operation acts on
       (popup               ; tame sudden yet inevitable temporary windows
        +all                ; catch all popups that start with an asterix
        +defaults)          ; default popup rules
       ;; (pretty-code
       ;;  +iosevka)           ; replace bits of code with pretty symbols
       ;;tabs               ; an tab bar for Emacs
       treemacs             ; a project drawer, like neotree but cooler
       ;;unicode            ; extended unicode support for various languages
       vc-gutter            ; vcs diff in the fringe
       vi-tilde-fringe      ; fringe tildes to mark beyond EOB
       window-select        ; visually switch windows
       workspaces           ; tab emulation, persistence & separate workspaces

       :editor
       (evil +everywhere)   ; come to the dark side, we have cookies
       file-templates       ; auto-snippets for empty files
       fold                 ; (nigh) universal code folding
       (format +onsave)     ; automated prettiness
       ;; lispy                ; vim for lisp, for people who dont like vim
       multiple-cursors     ; editing in many places at once
       ;;objed              ; text object editing for the innocent
       parinfer           ; turn lisp into python, sort of
       rotate-text          ; cycle region at point between text candidates
       snippets             ; my elves . They type so I don't have to

       :emacs
       (dired               ; making dired pretty [functional]
        ;; +ranger          ; bringing the goodness of ranger to dired
        +icons              ; colorful icons for dired-mode
        )
       electric             ; smarter, keyword-based electric-indent
       vc                   ; version-control and Emacs, sitting in a tree

       :term
       eshell            ; a consistent, cross-platform shell (WIP)
       ;;shell             ; a terminal REPL for Emacs
       term              ; terminals in Emacs
       ;;vterm             ; another terminals in Emacs

       :tools
       ansible
       ;;debugger           ; FIXME stepping through code, to help you add bugs
       ;;direnv
       docker
       editorconfig         ; let someone else argue about tabs vs spaces
       ;;ein                ; tame Jupyter notebooks with emacs
       eval                 ; run code, run (also, repls)
       flycheck             ; tasing you for every semicolon you forget
       flyspell             ; tasing you for misspelling mispelling
       ;;gist               ; interacting with github gists
       (lookup              ; helps you navigate your code and documentation
        +docsets)           ; . ..or in Dash docsets locally
       ;;lsp
       ;;macos              ; MacOS-specific commands
       magit                ; a git porcelain for Emacs
       make                 ; run make tasks from Emacs
       ;;pass               ; password manager for nerds
       ;;pdf                ; pdf enhancements
       ;;prodigy            ; FIXME managing external services & code builders
       ;;rgb                ; creating color strings
       terraform            ; infrastructure as code
       ;;tmux               ; an API for interacting with tmux
       ;;upload             ; map local to remote projects via ssh/ftp
       ;;wakatime

       :lang
       ;;agda               ; types of types of types of types...
       ;;assembly           ; assembly for fun or debugging
       ;;cc                 ; C/C++/Obj-C madness
       clojure              ; java with a lisp
       ;;common-lisp        ; if you've seen one lisp, you've seen them all
       ;;coq                ; proofs-as-programs
       ;;crystal            ; ruby at the speed of c
       ;;csharp             ; unity, .NET, and mono shenanigans
       data                 ; config/data formats
       ;;erlang             ; an elegant language for a more civilized age
       elixir               ; erlang done right
       ;;elm                ; care for a cup of TEA?
       emacs-lisp           ; drown in parentheses
       ;;ess                ; emacs speaks statistics
       ;;fsharp             ; ML stands for Microsoft's Language
       ;;go                 ; the hipster dialect
       ;;(haskell +intero)  ; a language that's lazier than I am
       ;;hy                 ; readability of scheme w/ speed of python
       ;;idris
       ;;(java +meghanada)  ; the poster child for carpal tunnel syndrome
       javascript           ; all(hope(abandon(ye(who(enter(here))))))
       ;;julia              ; a better, faster MATLAB
       ;;kotlin             ; a better, slicker Java(Script)
       ;;latex              ; writing papers in Emacs has never been so fun
       ;;ledger             ; an accounting system in Emacs
       ;;lua                ; one-based indices? one-based indices
       markdown             ; writing docs for people to ignore
       ;;nim                ; python + lisp at the speed of c
       ;;nix                ; I hereby declare "nix geht mehr!"
       ocaml                ; an objective camel
       (org                 ; organize your plain life in plain text
        +dragndrop          ; file drag & drop support
        +ipython            ; ipython support for babel
        +pandoc             ; pandoc integration into org's exporter
        +capture            ; org-capture in and outside of Emacs
        +protocol           ; support org-protocl links
        +present)           ; using Emacs for presentations
       ;;perl              ; write code no one else can comprehend
       ;;php               ; perl's insecure younger brother
       ;;plantuml           ; diagrams for confusing people more
       ;;purescript         ; javascript, but functional
       python               ; beautiful is better than ugly
       ;;qt                 ; the 'cutest' gui framework ever
       ;;racket             ; a DSL for DSLs
       ;;rest               ; Emacs as a REST client
       ;;ruby               ; 1.step {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}
       ;;rust               ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       ;;scala              ; java, but good
       ;;scheme             ; a fully conniving family of lisps
       (sh +fish)           ; she sells {ba,z,fi}sh shells on the C xor
       ;;solidity           ; do you need a blockchain? No.
       ;;swift              ; who asked for emoji variables?
       ;;terra              ; Earth and Moon in alignment for performance.
       web                  ; the tubes
       ;;vala               ; GObjective-C

       :email
       ;;(mu4e +gmail)       ; WIP
       ;;notmuch             ; WIP
       ;;(wanderlust +gmail) ; WIP

       ;; Applications are complex and opinionated modules that transform Emacs
       ;; toward a specific purpose. They may have additional dependencies and
       ;; should be loaded late.
       :app
       ;;calendar
       ;;irc                ; how neckbeards socialize
       ;;(rss +org)         ; emacs as an RSS reader
       ;;twitter            ; twitter client https://twitter.com/vnought
       (write               ; emacs as a word processor (latex + org + markdown)
        +wordnut            ; wordnet (wn) search
        +langtool)          ; a proofreader (grammar/style check) for Emacs

       :config
       ;; For literate config users. This will tangle+compile a config.org
       ;; literate config in your `doom-private-dir' whenever it changes.
       ;;literate

       ;; The default module sets reasonable defaults for Emacs. It also
       ;; provides a Spacemacs-inspired keybinding scheme and a smartparens
       ;; config. Use it as a reference for your own modules.
       (default +bindings +smartparens))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("427fa665823299f8258d8e27c80a1481edbb8f5463a6fb2665261e9076626710" "4ea0aa360264ff861fb0212abe4161b83ad1d8c8b74d8a04bcd1baf0ebdceeae" "1263771faf6967879c3ab8b577c6c31020222ac6d3bac31f331a74275385a452" "36746ad57649893434c443567cb3831828df33232a7790d232df6f5908263692" "f8fb7488faa7a70aee20b63560c36b3773bd0e4c56230a97297ad54ff8263930" "9129c2759b8ba8e8396fe92535449de3e7ba61fd34569a488dd64e80f5041c9f" "97965ccdac20cae22c5658c282544892959dc541af3e9ef8857dbf22eb70e82b" "4e132458143b6bab453e812f03208075189deca7ad5954a4abb27d5afce10a9a" "045496bf9a9de2be2266930507bf6533a0e61c4686994af5602d172ebab8347a" "ab9456aaeab81ba46a815c00930345ada223e1e7c7ab839659b382b52437b9ea" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
