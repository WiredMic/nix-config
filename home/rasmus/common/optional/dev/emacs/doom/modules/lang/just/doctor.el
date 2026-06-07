;;; lang/just/doctor.el -*- lexical-binding: t; -*-

(unless (executable-find "just")
  (error! "Couldn't find just in your PATH"))

(assert! (or (not (modulep! +tree-sitter))
             (modulep! :tools tree-sitter))
         "This module requires (:tools tree-sitter)")

(assert! (or (not (modulep! +lsp))
             (modulep! :tools lsp))
         "This module requires (:tools lsp)")

(when (modulep! +lsp)
  (unless (executable-find "just-lsp")
    (warn! "Couldn't find just-lsp in your PATH")))
