;;; lang/openscad/config.el -*- lexical-binding: t; -*-
;; https://github.com/Leathong/openscad-LSP

;; TODO use scadformat as a standalone binary

(defgroup openscad nil
  "OpenSCAD language support for Doom Emacs."
  :group 'languages
  :group 'programming)

(defcustom +openscad-lsp-server-path "openscad-lsp"
  "Path to the openscad-lsp binary."
  :group 'openscad
  :risky t
  :type 'file)

(defun +openscad-lsp-indent ()
  "Return the indentation string based on current buffer settings."
  (if indent-tabs-mode "\t" (make-string tab-width ?\s)))

(defun +openscad-lsp-setup-h ()
  "Configure LSP for OpenSCAD buffers."
  (when (modulep! +lsp)
    (if (modulep! :tools lsp -eglot)
        (progn
          (setq lsp-openscad-server +openscad-lsp-server-path)
          (lsp-register-custom-settings
           ;; https://github.com/emacs-lsp/lsp-mode/pull/5077
           `(("openscad.indent" ,(+openscad-lsp-indent))))
          (require 'lsp-openscad))
      (set-eglot-client! 'scad-mode `(,+openscad-lsp-server-path "--stdio")))
    (lsp!) (when (modulep! :editor format) (set-formatter! 'lsp :modes (list major-mode)))))


(when (and (modulep! :editor format) (not (modulep! +lsp)))
  (set-formatter! 'scadformat '("scadformat") :modes '(scad-mode)))

(use-package! scad-mode
  :when (not (modulep! +tree-sitter))
  :mode "\\.scad\\'"
  :hook (scad-mode . +openscad-lsp-setup-h)
  :config (map! :localleader
                :map scad-mode-map
                "e" #'scad-export
                "o" #'scad-open
                "p" #'scad-preview))
