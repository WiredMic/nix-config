;;; lang/typst/config.el -*- lexical-binding: t; -*-
;; https://myriad-dreamin.github.io/tinymist/frontend/emacs.html
;; https://github.com/emacs-lsp/lsp-mode/blob/master/clients/lsp-typst.el


;; TODO formatter

(defgroup typst nil
  "Typst language support for Doom Emacs."
  :group 'languages
  :group 'programming)

(defcustom +typst-lsp-server-path nil
  "Path to binary server file."
  :group 'typst
  :risky t
  :type 'file)

(defun +typst-lsp-setup-h ()
  "Run once at config time to register the LSP client."
  (when (modulep! +lsp)
    (if (modulep! :tools lsp -eglot)
        (after! lsp-mode
          (require 'lsp-typst)
          (when +typst-lsp-server-path
            (setq lsp-typst-server-command (list +typst-lsp-server-path)))
          (set-lsp-priority! 'tinymist 0) 
          )
      (after! eglot
        (set-eglot-client! 'typst-ts-mode
                           (lambda (&rest _)
                             (list (or +typst-lsp-server-path "tinymist"))))))))


(when (and (modulep! :editor format)
           (modulep! +lsp))     
  (set-formatter! 'lsp :modes '(typst-ts-mode)))

(use-package! typst-ts-mode
  :when (modulep! +tree-sitter)
  :mode "\\.typ\\'"
  :init
  (set-tree-sitter! nil 'typst-ts-mode
    '((typst :url "https://github.com/Ziqi-Yang/tree-sitter-typst"
       :commit "46cf4ded12ee974a70bf8457263b67ad7ee0379d")))
  :hook (typst-ts-mode . (lambda () (when (modulep! +lsp) (lsp!))))
  :config
  (+typst-lsp-setup-h))

