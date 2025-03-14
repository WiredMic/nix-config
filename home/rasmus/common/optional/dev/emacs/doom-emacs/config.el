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
     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 21)
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

(setq +format-on-save-enabled-modes
      '(not emacs-lisp-mode  ; elisp's mechanisms are good enough
	    sql-mode         ; sqlformat is currently broken
	    tex-mode         ; latexindent is broken
	    latex-mode))

(setq lsp-inlay-hint-enable t
      lsp-inlay-hints-mod t)

;; (with-eval-after-load 'lsp-mode
;;   (lsp-register-client
;;     (make-lsp-client :new-connection (lsp-stdio-connection "nixd")
;;                      :major-modes '(nix-mode)
;;                      :priority 0
;;                      :server-id 'nixd)))

(setq lsp-inlay-hint-enable t)
(setq lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
(setq lsp-rust-analyzer-display-chaining-hints t)
(setq lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names t)
(setq lsp-rust-analyzer-display-closure-return-type-hints t)
(setq lsp-rust-analyzer-display-parameter-hints t)
(setq lsp-rust-analyzer-display-reborrow-hints t)

(setq org-directory "~/OneDrive/Org/"
      org-roam-directory "~/OneDrive/Org/Roam")

(defun my/text-scale-adjust-latex-previews ()
  "Adjust the size of latex preview fragments when changing the
buffer's text scale."
  (pcase major-mode
    ('latex-mode
     (dolist (ov (overlays-in (point-min) (point-max)))
       (if (eq (overlay-get ov 'category)
               'preview-overlay)
           (my/text-scale--resize-fragment ov))))
    ('org-mode
     (dolist (ov (overlays-in (point-min) (point-max)))
       (if (eq (overlay-get ov 'org-overlay-type)
               'org-latex-overlay)
           (my/text-scale--resize-fragment ov))))))

(defun my/text-scale--resize-fragment (ov)
  (overlay-put
   ov 'display
   (cons 'image
         (plist-put
          (cdr (overlay-get ov 'display))
          :scale (+ 1.0 (* 0.25 text-scale-mode-amount))))))

(add-hook 'text-scale-mode-hook #'my/text-scale-adjust-latex-previews)

(setq org-preview-latex-default-process 'dvisvgm)

(setq org-modern-checkbox
      '((?X . "󰱒")
        (?\s . ""))
)

;; https://github.com/minad/org-modern
;; Minimal UI
(package-initialize)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)


(setq
;; Edit settings
org-auto-align-tags nil
org-tags-column 0
org-fold-catch-invisible-edits 'show-and-error
org-special-ctrl-a/e t
org-insert-heading-respect-content t

;; Org styling, hide markup etc.
org-hide-emphasis-markers t
org-pretty-entities t
org-ellipsis "…"
)

(global-org-modern-mode)

(defun my-org-faces ()
    (set-face-attribute 'org-todo nil :height 0.8)
    (set-face-attribute 'org-level-1 nil :height 1.2)
    (set-face-attribute 'org-level-2 nil :height 1.1))

(add-hook 'org-mode-hook #'my-org-faces)

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
;; (add-to-list 'org-latex-packages-alist'             t)

(use-package org-latex-preview
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

  ;; Turn on auto-mode, it's built into Org and much faster/more featured than
  ;; org-fragtog. (Remember to turn off/uninstall org-fragtog.)
  (add-hook 'org-mode-hook 'org-latex-preview-auto-mode)

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
  (setq org-latex-preview-live-debounce 0.25))

;; (require 'ox-latex)
;; (add-to-list 'org-latex-packages-alist '"\\lstset{ basicstyle=\\footnotesize\\ttfamily}")
(setq org-latex-src-block-backend "listings")
(add-to-list 'org-latex-packages-alist '("" "xcolor" t) t)
(add-to-list 'org-latex-packages-alist '("" "listings" t) t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base03}{HTML}{002B36}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base03}{HTML}{002B36}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base02}{HTML}{073642}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base01}{HTML}{586e75}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base00}{HTML}{657b83}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base0}{HTML}{839496}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base1}{HTML}{93a1a1}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base2}{HTML}{EEE8D5}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base3}{HTML}{FDF6E3}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@yellow}{HTML}{B58900}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@orange}{HTML}{CB4B16}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@red}{HTML}{DC322F}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@magenta}{HTML}{D33682}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@violet}{HTML}{6C71C4}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@blue}{HTML}{268BD2}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@cyan}{HTML}{2AA198}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@green}{HTML}{859900}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base02}{HTML}{073642}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base01}{HTML}{586e75}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base00}{HTML}{657b83}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base0}{HTML}{839496}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base1}{HTML}{93a1a1}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base2}{HTML}{EEE8D5}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@base3}{HTML}{FDF6E3}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@yellow}{HTML}{B58900}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@orange}{HTML}{CB4B16}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@red}{HTML}{DC322F}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@magenta}{HTML}{D33682}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@violet}{HTML}{6C71C4}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@blue}{HTML}{268BD2}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@cyan}{HTML}{2AA198}" t)
(add-to-list 'org-latex-packages-alist '"\\definecolor{solarized@green}{HTML}{859900}" t)
(setq org-latex-listings-options
      '(("basicstyle" "\\footnotesize\\ttfamily")
        ("captionpos" "b")
        ("columns" "flexible")
        ("breakatwhitespace" "false")
        ("breaklines" "true")
        ("keepspaces" "true")
        ("numbers" "left")
        ("numberstyle" "\\footnotesize")
        ("numbersep" "5pt")
        ("showspaces" "false")
        ("showstringspaces" "false")
        ("showtabs" "false")
        ("tabsize" "4")
        ("frame" "single")
        ("numberstyle" "\\tiny\\color{solarized@base01}")
        ("keywordstyle" "\\color{solarized@green}")
        ("stringstyle" "\\color{solarized@cyan}\ttfamily")
        ("identifierstyle" "\\color{solarized@blue}")
        ("commentstyle" "\\color{solarized@base01}")
        ("emphstyle" "\\color{solarized@red}")
        ("rulecolor" "\\color{solarized@base2}")
        ("rulesepcolor" "\\color{solarized@base2}")
        ))

;; (add-hook 'centaur-tabs-mode)

(use-package anki-editor
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

(use-package! valign
    :after org)
(add-hook 'org-mode-hook #'valign-mode)

(add-hook 'org-mode-hook #'pixel-scroll-precision-mode)

(setq org-roam-v2-ack t)

(use-package! org-roam
  :after org
  :config
  (setq org-roam-v2-ack t)
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

(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))
