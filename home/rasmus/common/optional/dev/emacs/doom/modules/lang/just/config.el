;;; lang/just/config.el -*- lexical-binding: t; -*-
;; https://github.com/leon-barrett/just-ts-mode.el

(defgroup just nil
  "Just language support for Doom Emacs."
  :group 'languages
  :group 'programming)

(defcustom +just-lsp-server-path "just-lsp"
  "Path to just-lsp binary."
  :group 'just
  :risky t
  :type 'file)

(defun +just-lsp-setup (mode)
  "Configure LSP for just modes."
  (when (modulep! +lsp)
    (if (modulep! :tools lsp -eglot)
        (progn
          (require 'lsp-just)
          (when +just-lsp-server-path
            (setq lsp-just-executable (list +just-lsp-server-path))))
      (set-eglot-client! mode (list +just-lsp-server-path)))))

(when (modulep! :editor format)
  (if (modulep! +lsp)
      (set-formatter! 'lsp :modes '(just-mode just-ts-mode))
    (after! apheleia
      (set-formatter! 'just
        '("just" "--unstable" "--dump"
          "--indentation"
          (if indent-tabs-mode
              "\t"
            (make-string tab-width ?\s))
          "--justfile" filepath)
        :modes '(just-mode just-ts-mode)))))

(use-package! just-mode
  :when (not (modulep! +tree-sitter))
  :mode ("Justfile\\'" "justfile\\'" "\\.just\\'")
  :hook (just-mode . (lambda () (when (modulep! +lsp) (lsp!))))
  :config
  (+just-lsp-setup 'just-mode))

(use-package! just-ts-mode
  :when (modulep! +tree-sitter)
  :mode ("Justfile\\'" "justfile\\'" "\\.just\\'")
  :init
  (set-tree-sitter! nil 'just-ts-mode
    '((typst :url "https://github.com/casey/tree-sitter-just"
       :commit "5685543a6e64f66335e25518c9ae8ffa1dae3d01")))
  :hook (just-ts-mode . (lambda () (when (modulep! +lsp) (lsp!))))
  :config
  (+just-lsp-setup 'just-ts-mode))

