;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Rasmus Enevoldsen"
      user-mail-address "rasmus@enev.dk")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrains Mono" :size 20)
     doom-variable-pitch-font (font-spec :family "FiraGO" :size 21)
     doom-symbol-font (font-spec :family "Nerd Font" :size 21)
     doom-serif-font (font-spec :family "JetBrains Mono" :size 20))

;; https://docs.doomemacs.org/v21.12/#/configuration/setting-ligatures

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; https://github.com/doomemacs/themes/tree/screenshots
(setq doom-theme 'doom-one)

(set-frame-parameter nil 'alpha-background 80) ; For current frame
(add-to-list 'default-frame-alist '(alpha-background . 80)) ; For all new frames henceforth

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/.local/share/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

  (use-package! vertico
    :init
    (vertico-mode)
    (vertico-multiform-mode)
    :config
    (setq vertico-multiform-categories
  	'((file reverse) ;; this is for finding files
  	  (command reverse) ;; this is for M-x
  	  (minor-mode reverse)
  	  (imenu buffer)
  	  (t reverse)))
    (setq vertico-multiform-commands
          '(
  	  ;; projectile
  	  (projectile-find-file reverse)
            (projectile-find-dir reverse)
            (projectile-switch-project reverse)
            (projectile-switch-to-buffer unobtrusive)
            ;; org-roam
  	  (org-roam-node-find reverse)
  	  (org-roam-node-insert reverse)
  	  )))

  ;; Emacs minibuffer configurations.
  ;; (use-package! emacs
    ;; :custom
    ;; ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
    ;; ;; to switch display modes.
    ;; (context-menu-mode t)
    ;; ;; Support opening new minibuffers from inside existing minibuffers.
    ;; (enable-recursive-minibuffers t)
    ;; ;; Hide commands in M-x which do not work in the current mode.  Vertico
    ;; ;; commands are hidden in normal buffers. This setting is useful beyond
    ;; ;; Vertico.
    ;; (read-extended-command-predicate #'command-completion-default-include-p)
    ;; ;; Do not allow the cursor in the minibuffer prompt
    ;; (minibuffer-prompt-properties
    ;;     '(read-only t cursor-intangible t face minibuffer-prompt)))

  ;; (use-package! orderless
  ;;   :ensure t
  ;;   :custom
  ;;   (completion-styles '(orderless basic))
  ;;   (completion-category-overrides '((file (styles basic partial-completion)))))

  ;; (define-key minibuffer-local-map (kbd "<backspace>") 'backward-kill-word)
  ;; (define-key minibuffer-local-map (kbd "DEL") 'backward-kill-word)

  (use-package! org
    :init
    (setq org-directory "~/Org/")
    )

  (use-package! org
    :config
    (dolist (face '((org-level-1 . 1.3)
  		  (org-level-2 . 1.25)
  		  (org-level-3 . 1.15)
  		  (org-level-4 . 1.1)
  		  (org-level-5 . 1.1)
  		  (org-level-6 . 1.1)
  		  (org-level-7 . 1.1)
  		  (org-level-8 . 1.1)))
      (set-face-attribute (car face) nil
  			:weight 'semi-bold
  			:height (cdr face)))
    )

  (use-package org
    :config
    (require 'org-indent)
    (set-face-attribute 'org-indent nil
  		      :inherit '(org-hide fixed-pitch))
    )

  (use-package org
    :config
    (set-face-attribute 'org-block nil
  		      ;; :foreground nil
  		      :inherit 'fixed-pitch
  		      :height 0.9)
    (set-face-attribute 'org-code nil
  		      :inherit '(shadow fixed-pitch)
  		      :height 0.9)
    (set-face-attribute 'org-indent nil
  		      :inherit '(org-hide fixed-pitch)
                        :height 0.85)
    (set-face-attribute 'org-verbatim nil
  		      :inherit '(shadow fixed-pitch)
  		      :height 0.85)
    (set-face-attribute 'org-special-keyword nil
  		      :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil
  		      :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil
  		      :inherit 'fixed-pitch)
    )

  (use-package! org
    :hook
    (org-mode . org-indent-mode)
    (org-mode . variable-pitch-mode)
    (org-mode . visual-line-mode)
    (org-mode-hook . pixel-scroll-precision-mode)
    (org-mode . (lambda () (display-line-numbers-mode 0)))
    )

  (use-package! org
    :config
    (setq org-pretty-entities            t
  	org-use-sub-superscripts       "{}"
  	org-hide-leading-stars         t
          org-ellipsis                   " ▼"
          org-startup-indented           t ;; TODO should not be here
          org-startup-with-inline-images t
  	)
    )

  (use-package! org-appear
    :commands (org-appear-mode)
    :hook     (org-mode . org-appear-mode)
    :config
    (setq org-hide-emphasis-markers t)  ; Must be activated for org-appear to work
    (setq org-appear-autoemphasis   t   ; Show bold, italics, verbatim, etc.
          org-appear-autolinks      t   ; Show links
  	org-appear-autosubmarkers t ; Show sub- and superscripts
  	)
    )

  (setq org-log-done                       t
        org-auto-align-tags                t
        org-tags-column                    -80
        org-fold-catch-invisible-edits     'show-and-error
        org-special-ctrl-a/e               t
        org-insert-heading-respect-content t
        )

  (use-package! org-modern
    :ensure t
    :after (org)
    :hook
    (org-mode . global-org-modern-mode)
    :config
    (setq org-modern-star 'replace)

    ;; (setq org-modern-keyword
    ;;     '(
    ;;       ("begin_src" . "≫")
    ;;       ("end_src" . "≪")
    ;;       ("begin_quote" . "❝")
    ;;       ("end_quote" . "❞")
    ;;         (t . t)
    ;;       )
    ;;     )

    (setq org-modern-checkbox
  	'(
  	  (88 . "")
  	  (45 . "")
  	  (32 . "")
  	  )
  	)

    (setq org-modern-priority
  	'(
  	  (?A . "🟥")
            (?B . "🟨")
            (?C . "🟩")
  	  )
  	)

    ;; Headings Starts
    (setq org-modern-replace-stars "◉○◈◇✳")

    ;; Lists
    (setq org-modern-list
  	'(
  	  (?- . "–") ;; -
  	  (?* . "•") ;; *
  	  (?+ . "‣") ;; +
  	  )
  	)
    ;; TODO
    (setq  org-modern-todo t
  	   org-todo-keywords '((sequence "TODO" "DONE")))
    (setq org-modern-todo-faces
  	'(
  	  ("TODO"
  	   :background "gold"
  	   :foreground "black"
  	   :width 'extra-expanded
  	   :weight 'ultra-bold
  	   :height 1.3
  	   :box (:line-width (0.1 . 0.1) :color "gold")
  	   )
  	  )
  	)

    )

  (with-eval-after-load 'org
    (setq org-auto-align-tags nil
          org-tags-column 0
          org-fold-catch-invisible-edits 'show-and-error
          org-special-ctrl-a/e t
          org-insert-heading-respect-content t
  	)
    (setq org-modern-hide-stars nil)
    )



  (use-package! org-modern-indent
    :after org-modern
    :config
  (set-face-attribute 'org-modern-indent-bracket-line nil :family "Jetbrains Mono" :height 1.1)
    :hook
    (org-modern-mode . org-modern-indent-mode)
    )

  ;; (defun my/prettify-symbols-setup ()

  ;;   ;; Drawers
  ;;   (push '(":PROPERTIES:" . "") prettify-symbols-alist)

  ;;   ;; Tags
  ;;   (push '(":projects:" . "") prettify-symbols-alist)
  ;;   (push '(":work:"     . "") prettify-symbols-alist)
  ;;   (push '(":inbox:"    . "") prettify-symbols-alist)
  ;;   (push '(":task:"     . "") prettify-symbols-alist)
  ;;   (push '(":thesis:"   . "") prettify-symbols-alist)
  ;;   (push '(":emacs:"    . "") prettify-symbols-alist)
  ;;   (push '(":learn:"    . "") prettify-symbols-alist)
  ;;   (push '(":code:"     . "") prettify-symbols-alist)

  ;;   (prettify-symbols-mode)
  ;;   )

  ;; (add-hook 'org-mode-hook        #'my/prettify-symbols-setup)
  ;; (add-hook 'org-agenda-mode-hook #'my/prettify-symbols-setup)

  (use-package! olivetti
    :after org
    :hook
    (org-mode . olivetti-mode)
    :config
    (setq olivetti-body-width 100)
    )

(use-package! valign
    :after org)
(add-hook 'org-mode-hook #'valign-mode)

  (use-package! org-roam
    :after org
    :init
    (setq org-roam-v2-ack t)
    :custom
    (org-roam-directory (expand-file-name "Roam" org-directory))
    (org-roam-completion-everywhere t)
    (setq org-roam-mode-sections
  	(list #'org-roam-backlinks-insert-section
                #'org-roam-reflinks-insert-section
                #'org-roam-unlinked-references-insert-section))
    :config
    (org-roam-db-autosync-enable)
    (org-roam-setup))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after (org-roam websocket)
    :config
        (setq org-roam-ui-sync-theme t
              org-roam-ui-follow t
              org-roam-ui-update-on-save t
              org-roam-ui-open-on-start nil))

  (map! :leader
        :desc  "Show graph ui"
    "n r g" #'org-roam-ui-open)

(setq org-roam-mode-sections
      (list #'org-roam-backlinks-section
            #'org-roam-reflinks-section
            #'org-roam-unlinked-references-section
            ))

(org-add-link-type "local-html" (lambda (path) (browse-url-xdg-open path)))

;; (add-to-list 'org-latex-packages-alist'("" "amsmath" t) t)
;; (add-to-list 'org-latex-packages-alist'("" "amssymb" t) t)
(add-to-list 'org-latex-packages-alist'("" "siunitx" t) t)
(add-to-list 'org-latex-packages-alist'("" "tikz" t) t)
(add-to-list 'org-latex-packages-alist '"\\usetikzlibrary{snakes,calc,patterns,angles,quotes,math,decorations.pathmorphing,decorations.text,decorations.pathreplacing,decorations.markings,automata,arrows.meta,positioning,external}" t)
(add-to-list 'org-latex-packages-alist'("european,siunitx" "circuitikz" t) t)
(add-to-list 'org-latex-packages-alist'("" "tikz-3dplot" t) t)
(add-to-list 'org-latex-packages-alist'("" "pgfplots" t) t)
(add-to-list 'org-latex-packages-alist'("" "derivative" t) t)
(add-to-list 'org-latex-packages-alist'("" "upgreek" t) t)

(add-to-list 'org-latex-packages-alist'("" "mysty9" t) t)

(use-package! org-latex-preview
  :config
  ;; Increase preview width
  (plist-put org-latex-preview-appearance-options
             :page-width 0.8)

  ;; Increase the size of the latex previews in the text
  (plist-put org-latex-preview-appearance-options
             :zoom 1.3)

  ;; Use dvisvgm to generate previews
  ;; You don't need this, it's the default:
  (setq org-latex-preview-process-default 'dvisvgm)

  ;; Block C-n, C-p etc from opening up previews when using auto-mode
  (setq org-latex-preview-auto-ignored-commands
        '(next-line previous-line mwheel-scroll
          scroll-up-command scroll-down-command))

  ;; Enable consistent equation numbering
  (setq org-latex-preview-numbered t)

  ;; Bonus: Turn on live previews.  This shows you a live preview of a LaTeX
  ;; fragment and updates the preview in real-time as you edit it.
  ;; To preview only environments, set it to '(block edit-special) instead
  (setq org-latex-preview-live t)

  ;; More immediate live-previews -- the default delay is 1 second
  (setq org-latex-preview-live-debounce 0.25)

  :hook
  (org-mode-hook . org-latex-preview-mode)
  )

(use-package! anki-editor
  :after org
  ;; (map! :leader
  ;;     :desc "Show graph ui"
  ;;     "n r a " #'anki-editor-cloze-region-auto-incr
  ;;     )
  ;;     "n r a" #'anki-editor-cloze-region-dont-incr
  ;;     "n r a" #'anki-editor-reset-cloze-number
  ;;     "n r a" #'anki-editor-push-tree

  :hook (org-capture-after-finalize . anki-editor-reset-cloze-number) ; Reset cloze-number after each capture.
  :config
  (setq anki-editor-create-decks t ;; Allow anki-editor to create a new deck if it doesn't exist
        anki-editor-org-tags-as-anki-tags t)

  (defun anki-editor-cloze-region-auto-incr (&optional arg)
    "Cloze region without hint and increase card number."
    (interactive)
    (anki-editor-cloze-region my-anki-editor-cloze-number "")
    (setq my-anki-editor-cloze-number (1+ my-anki-editor-cloze-number))
    (forward-sexp))
  (defun anki-editor-cloze-region-dont-incr (&optional arg)
    "Cloze region without hint using the previous card number."
    (interactive)
    (anki-editor-cloze-region (1- my-anki-editor-cloze-number) "")
    (forward-sexp))
  (defun anki-editor-reset-cloze-number (&optional arg)
    "Reset cloze number to ARG or 1"
    (interactive)
    (setq my-anki-editor-cloze-number (or arg 1)))
  (defun anki-editor-push-tree ()
    "Push all notes under a tree."
    (interactive)
    (anki-editor-push-notes '(4))
    (anki-editor-reset-cloze-number))
  ;; Initialize
  (anki-editor-reset-cloze-number))

(use-package! org-roam
  :after org
  :init
  (setq org-roam-v2-ack t)
  :config
  (setq org-roam-completion-everywhere t)
  (setq org-roam-mode-sections
  (list #'org-roam-backlinks-insert-section
        #'org-roam-reflinks-insert-section
        #'org-roam-unlinked-references-insert-section))
  (org-roam-db-autosync-enable))

(setq org-roam-mode-sections
      (list #'org-roam-backlinks-section
            #'org-roam-reflinks-section
            #'org-roam-unlinked-references-section
            ))

(org-babel-do-load-languages
 'org-babel-load-languages '((C . t)))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start nil)

    (map! :leader
      :desc "Show graph ui"
      "n r g" #'org-roam-ui-open)
)

(map! :after org-roam
      :leader
      :desc "Give ID to a Heading"
      "n r h" #'org-id-get-create)

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config (setq org-auto-tangle-default t))

(require 'org-download)

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)
(setq org-download-image-html-width '450
      org-download-image-latex-width '7
      org-download-image-org-width '450)

  ;; (use-package org-transclusion
  ;;   :after org
  ;;   ;; :init
  ;;   ;; (map!
  ;;   ;;  :map global-map "<f12>" #'org-transclusion-add
  ;;   ;;  :leader
  ;;   ;;  :prefix "n"
  ;;   ;;  :desc "Org Transclusion Mode" "t" #'org-transclusion-mode)
  ;;   )

;; (defun unpack-image-drawers (&rest r)
;;   "Replace drawers named \"IMAGE_INFO\" with their contents."
;;   (let* ((drawer-name "IMAGE_INFO")
;;         (save-string "#+ATTR_SAVE: true\n")
;;         (image-drawers (reverse (org-element-map (org-element-parse-buffer)
;;                                 'drawer
;;                               (lambda (el)
;;                                 (when (string= drawer-name (org-element-property :drawer-name el))
;;                                   el))))))
;;     (cl-loop for drawer in image-drawers do
;;              (setf (buffer-substring (org-element-property :begin drawer)
;;                                      (- (org-element-property :end drawer) 1))
;;                    (concat save-string
;;                            (buffer-substring (org-element-property :contents-begin drawer)
;;                                              (- (org-element-property :contents-end drawer) 1)))))))

;; (defun repack-image-drawers (&rest r)
;;   "Restore image drawers replaced using `unpack-image-drawers'."
;;   (let* ((drawer-name "IMAGE_INFO")
;;         (save-string "#+ATTR_SAVE: true\n")
;;         (image-paragraphs (reverse (org-element-map (org-element-parse-buffer)
;;                                'paragraph
;;                              (lambda (el)
;;                                (when (string= "true" (nth 0 (org-element-property :attr_save el)))
;;                                  el))))))
;;     (cl-loop for paragraph in image-paragraphs do
;;              (setf (buffer-substring (org-element-property :begin paragraph)
;;                                      (- (org-element-property :contents-begin paragraph) 1))
;;                    (concat ":" drawer-name ":\n"
;;                            (buffer-substring (+ (length save-string) (org-element-property :begin paragraph))
;;                                              (- (org-element-property :contents-begin paragraph) 1))
;;                            "\n:END:")))))


;; (defun apply-with-image-drawers-unpacked (f &rest r)
;;   "Replace drawers named \"IMAGE_INFO\" with their contents, run the function,
;; finally restore the drawers as they were. Also collapses all drawers before returning."
;;   (unpack-image-drawers)
;;   (apply f r)
;;   (repack-image-drawers)
;;   (org-hide-drawer-all))

;; (advice-add #'org-display-inline-images :around #'apply-with-image-drawers-unpacked)
;; (add-hook 'org-export-before-processing-hook 'unpack-image-drawers)

(setq +format-on-save-enabled-modes
      '(not emacs-lisp-mode  ; elisp's mechanisms are good enough
	sql-mode         ; sqlformat is currently broken
	;; tex-mode         ; latexindent is broken
	;; latex-mode
        ))

(setq lsp-inlay-hint-enable t
      lsp-inlay-hints-mod t)

;; (with-eval-after-load 'lsp-mode
;;   (lsp-register-client
;;     (make-lsp-client :new-connection (lsp-stdio-connection "nixd")
;;                      :major-modes '(nix-mode)
;;                      :priority 0
;;                      :server-id 'nixd)))
(use-package! nix-mode)

(use-package! rust-mode
  :config
  (setq lsp-inlay-hint-enable t)
  (setq lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (setq lsp-rust-analyzer-display-chaining-hints t)
  (setq lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names t)
  (setq lsp-rust-analyzer-display-closure-return-type-hints t)
  (setq lsp-rust-analyzer-display-parameter-hints t)
  (setq lsp-rust-analyzer-display-reborrow-hints t)
  (setq lsp-rust-all-features t)
  )

(setq lsp-clients-clangd-args '("-j=3"
				"--background-index"
				"--clang-tidy"
				"--completion-style=detailed"
				"--header-insertion=never"
				"--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

  ;; Explicitly remove objective-c association and add octave
  (setq auto-mode-alist
        (rassq-delete-all 'objc-mode auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

(use-package! octave
  ;; :ensure nil
  :after lsp
  ;; :init
  :mode "\\.m\\'"
  :hook (octave-mode . lsp-deferred)
  :config
  ;; (add-to-list 'lsp-language-id-configuration '(".*\\.m$" . "octave"))
  (add-to-list 'lsp-language-id-configuration '(octave-mode . "octave"))
  (lsp-register-client (make-lsp-client
                        :new-connection (lsp-stdio-connection "matlab-language-server")
                        :major-modes 'octave-mode
                        ;; :activation-fn (lsp-activate-on "octave")
                        :server-id 'matlab-language-server))
  )

;;; scad-mode.el --- A major mode for editing OpenSCAD code -*- lexical-binding: t -*-

;; Author: Len Trigg, Łukasz Stelmach, zk_phi, Daniel Mendler
;; Maintainer: Len Trigg <lenbok@gmail.com>, Daniel Mendler <mail@daniel-mendler.de>
;; Created: 2010
;; Keywords: languages
;; URL: https://github.com/openscad/emacs-scad-mode
;; Package-Requires: ((emacs "28.1") (compat "30"))
;; Version: 96.0

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; This is a major-mode to implement the SCAD constructs and
;; font-locking for OpenSCAD.  Install the package from NonGNU ELPA or
;; MELPA:
;;
;; M-x install-package RET scad-mode RET

;;; Code:

(require 'compat)
(require 'cc-mode)
(eval-when-compile
  (require 'cc-langs)
  (require 'cc-fonts)
  (require 'cl-lib))

(defgroup scad nil
  "A major mode for editing OpenSCAD code."
  :link '(url-link :tag "Website" "https://github.com/openscad/emacs-scad-mode")
  :link '(emacs-library-link :tag "Library Source" "scad-mode.el")
  :group 'languages
  :prefix "scad-")

(defcustom scad-command
  "openscad"
  "Path to openscad executable."
  :type 'string)

(defcustom scad-extra-args
  nil
  "Additional command line arguments to pass to openscad.
For example '--enable=manifold'."
  :type '(repeat string))

(defcustom scad-keywords
  '("return" "undef" "true" "false" "for" "each" "if" "else" "let" "intersection_for"
    "function" "use" "include" "module")
  "SCAD keywords."
  :type '(repeat string))

(defcustom scad-functions
  '("cos" "acos" "sin" "asin" "tan" "atan" "atan2"                      ;;func.cc
    "abs" "sign" "rands" "min" "max"
    "round" "ceil" "floor"
    "pow" "sqrt" "exp" "log" "ln"
    "str"
    "lookup" "version" "version_num" "len" "search"
    "dxf_dim" "dxf_cross"                                               ;;dxfdim.cc
    "norm" "cross"                                                      ;;2014.03
    "concat" "chr"                                                      ;;2015.03
    "assert" "ord"                                                      ;;2019.05
    "is_undef" "is_list" "is_num" "is_bool" "is_string" "is_function")  ;;2019.05 type test
  "SCAD functions."
  :type '(repeat string))

(defcustom scad-modules
  '("children" "echo"                                                   ;;control.cc
    "cube" "sphere" "cylinder" "polyhedron" "square" "circle" "polygon" ;;primitives.cc
    "scale" "rotate" "translate" "mirror" "multmatrix"                  ;;transform.cc
    "union" "difference" "intersection"                                 ;;csgops.cc
    "render"                                                            ;;render.cc
    "color"                                                             ;;color.cc
    "surface"                                                           ;;surface.cc
    "linear_extrude"                                                    ;;linearextrude.cc
    "rotate_extrude"                                                    ;;rotateextrude.cc
    "import"                                                            ;;import.cc
    "group"                                                             ;;builtin.cc
    "projection"                                                        ;;projection.cc
    "minkowski" "hull" "resize"                                         ;;cgaladv.cc
    "parent_module"                                                     ;;2014.03
    "offset" "text")                                                    ;;2015.03
  "SCAD modules."
  :type '(repeat string))

(defcustom scad-deprecated
  '("child" "assign" "dxf_linear_extrude" "dxf_rotate_extrude"
    "import_stl" "import_off" "import_dxf")
  "SCAD deprecated modules and functions."
  :type '(repeat string))

(defcustom scad-operators
  '("+" "-" "*" "/" "%"
    "&&" "||" "!"
    "<" "<=" "==" "!=" ">" ">="
    "?" ":" "=")
  "SCAD operators."
  :type '(repeat string))

(defcustom scad-preview-projection 'perspective
  "Preview projection."
  :type '(choice (const ortho) (const perspective)))

(defcustom scad-preview-camera '(0 0 0 50 0 20 500)
  "Default parameters for the Gimbal camera."
  :type '(repeat integer))

(defcustom scad-preview-refresh 1.0
  "Delay in seconds until updating preview."
  :type '(choice (const nil) number))

(defcustom scad-preview-colorscheme '("Tomorrow" . "Tomorrow Night")
  "Color scheme for rendering preview.
Can be pair of light and dark scheme, used depending on the current
Emacs theme."
  :type '(choice string (cons string string)))

(defcustom scad-preview-view '("axes" "scales")
  "List of views to be rendered.
Options are axes, crosshairs, edges, scales, wireframe."
  :type '(repeat string))

(defcustom scad-export-extension ".stl"
  "Extension (file type) for output data file via `scad-export'.
Options are .stl, .off, .amf, .3mf, .csg, .dxf, .svg, .pdf, .png,
.echo, .ast, .term, .nef3, .nefdbg."
  :type 'string)

(defvar-keymap scad-mode-map
  :doc "Keymap for `scad-mode'."
  :parent c-mode-base-map
  "C-c C-c" #'scad-preview
  "C-c C-o" #'scad-open
  "C-c C-e" #'scad-export
  "TAB" #'indent-for-tab-command
  "M-TAB" #'completion-at-point)

(defvar scad-mode-syntax-table
  (let ((st (make-syntax-table)))
    (c-populate-syntax-table st)
    st)
  "Syntax table for `scad-mode'.")

(defvar scad-font-lock-keywords
  `(("\\(module\\|function\\)[ \t]+\\(\\sw+\\)" (1 'font-lock-keyword-face nil) (2 'font-lock-function-name-face nil t))
    ("\\(use\\|include\\)[ \t]*<\\([^>]+\\)>" (1 'font-lock-preprocessor-face nil) (2 'font-lock-type-face nil t))
    ("<\\(\\sw+\\)>\\|$\\(\\sw+\\)" . font-lock-builtin-face)
    (,(regexp-opt scad-keywords 'words)   . font-lock-keyword-face)
    (,(regexp-opt scad-modules 'words)    . font-lock-builtin-face)
    (,(regexp-opt scad-functions 'words)  . font-lock-function-name-face)
    (,(regexp-opt scad-deprecated 'words) . font-lock-warning-face)
    ;(,(regexp-opt scad-operators) . font-lock-operator-face) ;; This actually looks pretty ugly
    ;("\\(\\<\\S +\\>\\)\\s *(" 1 font-lock-function-name-face t) ;; Seems to override other stuff (e.g. in comments and builtins)
    )
  "Keyword highlighting specification for `scad-mode'.")
(defconst scad-font-lock-keywords-1 scad-font-lock-keywords)
(defconst scad-font-lock-keywords-2 scad-font-lock-keywords)
(defconst scad-font-lock-keywords-3 scad-font-lock-keywords)

(defvar scad-completions
  (append scad-keywords scad-functions scad-modules)
  "List of known words for completion.")

(put 'scad-mode 'c-mode-prefix "scad-")

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.scad\\'" . scad-mode))

;;;###autoload
(define-derived-mode scad-mode prog-mode "SCAD"
  "Major mode for editing OpenSCAD code."
  :group 'scad
  :after-hook (c-update-modeline)
  (add-hook 'flymake-diagnostic-functions #'scad-flymake nil 'local)
  (add-hook 'completion-at-point-functions
            #'scad-completion-at-point nil 'local)
  (c-initialize-cc-mode t)
  (c-init-language-vars scad-mode)
  (c-common-init 'scad-mode)
  (c-set-offset 'cpp-macro 0 nil)
  (c-run-mode-hooks 'c-mode-common-hook))

(defun scad-completion-at-point ()
  "Completion at point function."
  (when-let (bounds (bounds-of-thing-at-point 'word))
    (list (car bounds) (cdr bounds)
          scad-completions
          :exclusive 'no)))

(defun scad-open ()
  "Open current buffer with `scad-command'."
  (interactive nil scad-mode)
  (save-buffer)
  (call-process scad-command nil 0 nil (buffer-file-name)))

(defun scad-export (file)
  "Render and export current SCAD model to FILE."
  (interactive
   (list (read-file-name
          "Export to: "
          nil nil nil
          (concat (file-name-base (buffer-file-name))
                  scad-export-extension)))
   scad-mode)
  (save-buffer)
  (compile (string-join (append (list scad-command)
                                (list "-o"
                                      (shell-quote-argument (expand-file-name file))
                                      (shell-quote-argument (buffer-file-name)))
                                scad-extra-args) " ")))

(defvar-local scad--preview-buffer      nil)
(defvar-local scad--preview-proc        nil)
(defvar-local scad--preview-image       nil)
(defvar-local scad--preview-mode-status nil)
(defvar-local scad--preview-mode-camera nil)
(defvar-local scad--preview-timer       nil)

(defvar-keymap scad-preview-mode-map
  :doc "Keymap for SCAD preview buffers."
  "p" #'scad-preview-projection
  "-" #'scad-preview-distance-
  "+" #'scad-preview-distance+
  "<right>" #'scad-preview-rotate-z-
  "<left>" #'scad-preview-rotate-z+
  "<up>" #'scad-preview-rotate-x+
  "<down>" #'scad-preview-rotate-x-
  "M-<left>" #'scad-preview-translate-x+
  "M-<right>" #'scad-preview-translate-x-
  "M-<up>" #'scad-preview-translate-z-
  "M-<down>" #'scad-preview-translate-z+)

(defun scad--preview-status (status)
  "Update mode line of preview buffer with STATUS."
  (setq scad--preview-mode-camera (apply #'format "[%d %d %d] [%d %d %d] %d"
                                         scad-preview-camera)
        scad--preview-mode-status status)
  (force-mode-line-update))

(defun scad-preview ()
  "Preview SCAD models in real-time within Emacs."
  (interactive nil scad-mode)
  (unless (buffer-live-p scad--preview-buffer)
    (setq scad--preview-buffer
          (with-current-buffer (get-buffer-create (format "*scad preview: %s*" (buffer-name)))
            (scad-preview-mode)
            (current-buffer))))
  (when scad-preview-refresh
    (add-hook 'after-change-functions #'scad--preview-change nil 'local))
  (let ((orig-buffer (current-buffer)))
    (with-current-buffer scad--preview-buffer
      (setq scad--preview-buffer orig-buffer)
      (scad--preview-reset))))

(defun scad--preview-change (&rest _)
  "Buffer changed, trigger rerendering."
  (if (not (buffer-live-p scad--preview-buffer))
      (remove-hook 'after-change-functions #'scad--preview-change 'local)
    (let ((buffer scad--preview-buffer))
      (with-current-buffer buffer
        (scad--preview-kill)
        (scad--preview-status "Stale")
        (setq scad--preview-timer
              (run-with-timer
               scad-preview-refresh nil
               (lambda ()
                 (when (buffer-live-p buffer)
                   (with-current-buffer buffer
                     (setq scad--preview-timer nil)
                     (scad--preview-render))))))))))

(defun scad--preview-colorscheme ()
  "Color scheme depending on Emacs theme."
  (cond
   ((stringp scad-preview-colorscheme)
    scad-preview-colorscheme)
   ((color-dark-p (color-name-to-rgb (face-background 'default)))
    (cdr scad-preview-colorscheme))
   (t (car scad-preview-colorscheme))))

(defun scad--preview-reset (&rest _)
  "Reset camera settings and render."
  (setq-local scad-preview-camera (copy-sequence (default-value 'scad-preview-camera))
              scad-preview-projection (default-value 'scad-preview-projection))
  (scad--preview-render))

;; Based on https://github.com/zk-phi/scad-preview
(defun scad--preview-render (&rest _)
  "Render image from current buffer."
  (if (not (buffer-live-p scad--preview-buffer))
      (scad--preview-status "Dead")
    (scad--preview-kill)
    (scad--preview-status "Render")
    (let* ((infile (make-temp-file "scad-preview-" nil ".scad"))
           (basefile (file-name-sans-extension infile))
           (outfile (concat basefile ".tmp.png"))
           (buffer (current-buffer))
           (win (or (get-buffer-window buffer)
                    (display-buffer
                     buffer '(nil (inhibit-same-window . t))))))
      (with-current-buffer scad--preview-buffer
        (save-restriction
          (widen)
          (write-region (point-min) (point-max) infile nil 'nomsg)))
      (with-environment-variables
          ;; Setting the OPENSCADPATH to the current directory allows openscad to pick
          ;; up other local files with `include <file.scad>'.
          (("OPENSCADPATH"
            (if-let ((path (getenv "OPENSCADPATH")))
                (concat default-directory path-separator path)
              default-directory)))
        (setq scad--preview-proc
              (make-process
               :noquery t
               :connection-type 'pipe
               :name "scad-preview"
               :buffer "*scad preview output*"
               :sentinel
               (lambda (proc _event)
                 (unwind-protect
                     (when (and (buffer-live-p buffer)
                                (memq (process-status proc) '(exit signal)))
                       (with-current-buffer buffer
                         (setq scad--preview-proc nil)
                         (if (not (ignore-errors
                                    (and (file-exists-p outfile)
                                         (> (file-attribute-size (file-attributes outfile)) 0))))
                             (scad--preview-status "Error")
                           (with-silent-modifications
                             (scad--preview-delete)
                             (setq scad--preview-image (concat basefile ".png"))
                             (rename-file outfile scad--preview-image)
                             (erase-buffer)
                             (insert (propertize "#" 'display `(image :type png :file ,scad--preview-image))))
                           (scad--preview-status "Done"))))
                   (delete-file infile)
                   (delete-file outfile)))
               :command
               (append
                (list scad-command
                      "-o" outfile
                      "--preview"
                      (format "--projection=%s" scad-preview-projection)
                      (format "--imgsize=%d,%d"
                              (window-pixel-width win)
                              (window-pixel-height win))
                      (format "--view=%s"
                              (mapconcat #'identity scad-preview-view ","))
                      (format "--camera=%s"
                              (mapconcat #'number-to-string scad-preview-camera ","))
                      (format "--colorscheme=%s" (scad--preview-colorscheme))
                      infile)
                scad-extra-args)))))))

(defun scad--preview-kill ()
  "Kill current rendering."
  (when (process-live-p scad--preview-proc)
    (delete-process scad--preview-proc)
    (setq scad--preview-proc nil))
  (when scad--preview-timer
    (cancel-timer scad--preview-timer)
    (setq scad--preview-timer nil)))

(defun scad--preview-delete ()
  "Delete current image."
  (when scad--preview-image
    (delete-file scad--preview-image)
    (setq scad--preview-image nil)))

(define-derived-mode scad-preview-mode special-mode "SCAD/Preview"
  "Major mode for SCAD preview buffers."
  :interactive nil :abbrev-table nil :syntax-table nil
  (setq-local buffer-read-only t
              line-spacing nil
              cursor-type nil
              cursor-in-non-selected-windows nil
              left-fringe-width 1
              right-fringe-width 1
              left-margin-width 0
              right-margin-width 0
              truncate-lines nil
              show-trailing-whitespace nil
              display-line-numbers nil
              fringe-indicator-alist '((truncation . nil))
              revert-buffer-function #'scad--preview-reset
              mode-line-position '(" " scad--preview-mode-camera)
              mode-line-process '(" " scad--preview-mode-status)
              mode-line-modified nil
              mode-line-mule-info nil
              mode-line-remote nil)
  (add-hook 'kill-buffer-hook #'scad--preview-kill nil 'local)
  (add-hook 'kill-buffer-hook #'scad--preview-delete nil 'local)
  (add-hook 'window-size-change-functions
            (let ((buf (current-buffer)))
              (lambda (_)
                (with-current-buffer buf
                  (scad--preview-render))))
            nil 'local))

(defun scad-preview-projection ()
  "Toggle projection."
  (interactive nil scad-preview-mode)
  (setq-local scad-preview-projection
              (if (eq scad-preview-projection 'ortho)
                  'perspective
                'ortho))
  (scad--preview-render))

(defmacro scad--define-preview-move (name idx off)
  "Define camera move function NAME which increments IDX by OFF."
  `(defun ,(intern (format "scad-preview-%s" name)) (&optional offset)
     "Move camera by OFFSET."
     (interactive "P" scad-preview-mode)
     (cl-incf (nth ,idx scad-preview-camera)
              (* (cl-signum ,off)
                 (if offset (prefix-numeric-value offset) ,(abs off))))
     (scad--preview-render)))

(scad--define-preview-move translate-x+ 0 10)
(scad--define-preview-move translate-x- 0 -10)
(scad--define-preview-move translate-y+ 1 10)
(scad--define-preview-move translate-y- 1 -10)
(scad--define-preview-move translate-z+ 2 10)
(scad--define-preview-move translate-z- 2 -10)
(scad--define-preview-move rotate-x+ 3 20)
(scad--define-preview-move rotate-x- 3 -20)
(scad--define-preview-move rotate-y+ 4 20)
(scad--define-preview-move rotate-y- 4 -20)
(scad--define-preview-move rotate-z+ 5 20)
(scad--define-preview-move rotate-z- 5 -20)
(scad--define-preview-move distance- 6 100)
(scad--define-preview-move distance+ 6 -100)

(defvar-local scad--flymake-proc nil)

(defun scad-flymake (report-fn &rest _args)
  "Flymake backend, diagnostics are passed to REPORT-FN."
  (unless (executable-find scad-command)
    (error "Cannot find `%s'" scad-command))
  (when (process-live-p scad--flymake-proc)
    (delete-process scad--flymake-proc))
  (let* ((buffer (current-buffer))
         (infile (make-temp-file "scad-flymake-" nil ".scad"))
         (outfile (concat (file-name-sans-extension infile) ".ast")))
    (save-restriction
      (widen)
      (write-region (point-min) (point-max) infile nil 'nomsg))
    (with-environment-variables
        ;; Setting the OPENSCADPATH to the current directory allows openscad to pick
        ;; up other local files with `include <file.scad>'.
        (("OPENSCADPATH"
          (if-let ((path (getenv "OPENSCADPATH")))
              (concat default-directory path-separator path)
            default-directory)))
      (setq
       scad--flymake-proc
       (make-process
        :name "scad-flymake"
        :noquery t
        :connection-type 'pipe
        :buffer (generate-new-buffer " *scad-flymake*")
        :command (append (list scad-command "-o" outfile infile) scad-extra-args)
        :sentinel
        (lambda (proc _event)
          (when (memq (process-status proc) '(exit signal))
            (unwind-protect
                (when (and (buffer-live-p buffer)
                           (eq proc (buffer-local-value 'scad--flymake-proc buffer)))
                  (with-current-buffer (process-buffer proc)
                    (goto-char (point-min))
                    (let (diags)
                      (while (search-forward-regexp "^\\(ERROR\\|WARNING\\): \\(.*?\\),? in file [^,]+, line \\([0-9]+\\)" nil t)
                        (let ((msg (match-string 2))
                              (type (if (equal (match-string 1) "ERROR") :error :warning))
                              (region (flymake-diag-region buffer (string-to-number (match-string 3)))))
                          (push (flymake-make-diagnostic buffer (car region) (cdr region) type msg) diags)))
                      (funcall report-fn (nreverse diags)))))
              (delete-file outfile)
              (delete-file infile)
              (kill-buffer (process-buffer proc))))))))))

(provide 'scad-mode)
;;; scad-mode.el ends here

(use-package! scad-mode
  :config
  ;; (when (modulep! +lsp
    (add-hook 'scad-mode-local-vars-hook #'lsp! 'append)
    ;; )
  (map! (:localleader
         (:map (scad-mode-map)
               "e" #'scad-export
               "o" #'scad-open
               "p" #'scad-preview))))

(use-package! vhdl-mode
  ;; :mode "\\.vhd\\'"
  :hook
  (vhdl-mode . lsp-deferred)
  :config
  (setq lsp-vhdl-server 'vhdl-ls
        lsp-vhdl-server-path "vhdl_ls")

  ;; ligatures
  (set-ligatures! 'vhdl-mode
    nil
    )
  )

(use-package! vhdl-ts-mode
  :mode (("\\.\\(vhd\\(?:l?\\)?\\)" . vhdl-ts-mode))
  :when (and (treesit-available-p)
             (treesit-language-available-p 'vhdl) ; vhdl-ts-install-grammar
             (treesit-ready-p 'vhdl t))
  :bind
  (:map vhdl-ts-mode-map
        ("C-c C-b" . nil) ; vhdl-ts-beautify-buffer
        ("C-M-u" . #'vhdl-ts-find-entity-instance-bwd))
  :custom
  (vhdl-ts-indent-level 2)
  (vhdl-ts-imenu-style 'tree-group)
  (vhdl-ts-beautify-align-ports-and-params t)
  :hook
  (vhdl-mode . lsp-deferred)
  (vhdl-ts-mode . (lambda ()
                    (vhdl-ext-mode)
                    (require 'fpga)
                    (superword-mode -1)
                    (subword-mode t)
                    (when outline-minor-mode
                      (setq-local
                       outline-regexp
                       "^\\s-*--\\s-\\([*]\\{1,8\\}\\)\\s-\\(.*\\)$"))
                    ;; otherwise, I’m unable to make imenu work properly
                    (setq-local eglot-stay-out-of (list 'imenu))))
  :config
  (setq lsp-vhdl-server 'vhdl-ls
        lsp-vhdl-server-path "vhdl_ls")

  ;; format on sav
  (set-formatter! 'vhdl-beautify
    (lambda (&rest args)
      (let ((scratch (plist-get args :scratch))
            (callback (plist-get args :callback)))
        ;; Switch to the scratch buffer and beautify it
        (with-current-buffer scratch
          (let ((vhdl-mode-hook nil)) ; Avoid running hooks
            ;; Temporarily set the major mode to vhdl-mode for beautify function
            (let ((original-mode major-mode))
              (vhdl-mode)
              ;; Run the beautify function
              (vhdl-beautify-region (point-min) (point-max))
              ;; Restore original mode if different
              (unless (eq original-mode 'vhdl-mode)
                (funcall original-mode)))))
        ;; Call the success callback
        (funcall callback nil)))
    :modes '(vhdl-mode))

  ;; Does not Run on save
  (set-formatter! 'vhdl-ts-beautify
    (lambda (&rest args)
      (let ((scratch (plist-get args :scratch))
            (callback (plist-get args :callback)))
        ;; Switch to the scratch buffer and beautify it
        (with-current-buffer scratch
          (let ((vhdl-mode-hook nil)) ; Avoid running hooks
            ;; Temporarily set the major mode to vhdl-mode for beautify function
            (let ((original-mode major-mode))
              (vhdl-mode)
              ;; Run the beautify function
              (vhdl-beautify-region (point-min) (point-max))
              ;; Restore original mode if different
              (unless (eq original-mode 'vhdl-ts-mode)
                (funcall original-mode)))))
        ;; Call the success callback
        (funcall callback nil)))
    :modes '(vhdl-ts-mode))

  ;; ligatures
  (set-ligatures! 'vhdl-ts-mode
    nil
    )
  )

(use-package! vhdl-ext
  :hook ((vhdl-mode . vhdl-ext-mode))
  :hook ((vhdl-ts-mode . vhdl-ext-mode))
  :init
  ;; Can also be set through `M-x RET customize-group RET vhdl-ext':
  ;; Comment out/remove the ones you do not need
  (setq vhdl-ext-feature-list
        '(
          ;; font-lock
          ;; xref
          ;; capf
          ;; hierarchy
          ;; eglot
          lsp
          ;; lsp-bridge
          ;; lspce
          flycheck
          beautify
          ;; navigation
          ;; template
          ;; compilation
          ;; imenu
          ;; which-func
          hideshow
          ;; time-stamp
          ;; ports
          )
        )
  :config
  (setq vhdl-modify-date-on-saving nil)
  (vhdl-ext-mode-setup))

(use-package! typst-ts-mode
  :mode "\\.typ\\'"
  :hook (typst-ts-mode . lsp-deferred)
  :init
  ;; Ensure tree-sitter grammar is available
  (add-to-list 'treesit-language-source-alist
               '(typst "https://github.com/uben0/tree-sitter-typst"))
  :config
  (after! lsp-mode
    ;; Add language ID configuration
    (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))

    ;; Register tinymist LSP client
    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection "tinymist")
      :activation-fn (lsp-activate-on "typst")
      :major-modes '(typst-ts-mode)
      :server-id 'tinymist))))

(after! projectile
  (add-to-list 'projectile-project-root-files "platformio.ini"))
