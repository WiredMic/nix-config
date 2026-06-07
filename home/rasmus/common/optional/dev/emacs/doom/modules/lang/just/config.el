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

(defun +just-lsp-setup-h ()
  "Configure LSP for just modes."
  (when (modulep! +lsp)
    (if (modulep! :tools lsp -eglot)
        (progn
          (require 'lsp-just)
          (when +just-lsp-server-path
            (setq lsp-just-executable (list +just-lsp-server-path))))
      (set-eglot-client! major-mode
                         (list +just-lsp-server-path)))
    (lsp!)
    (when (modulep! :editor format)
      (set-formatter! 'lsp :modes (list major-mode)))))

(when (and (modulep! :editor format)
           (not (modulep! +lsp)))
  (after! apheleia
    (set-formatter! 'just
      '("just" "--unstable" "--dump"
        "--indentation"
        (if indent-tabs-mode
            "\t"
          (make-string tab-width ?\s))
        "--justfile" filepath)
      :modes '(just-mode just-ts-mode))))

(use-package! just-mode
  :when (not (modulep! +tree-sitter))
  :mode ("Justfile\\'" "justfile\\'" "\\.just\\'")
  :hook (just-mode . +just-lsp-setup-h))

(use-package! just-ts-mode
  :when (modulep! +tree-sitter)
  :mode ("Justfile\\'" "justfile\\'" "\\.just\\'")
  :hook (just-ts-mode . +just-lsp-setup-h))

