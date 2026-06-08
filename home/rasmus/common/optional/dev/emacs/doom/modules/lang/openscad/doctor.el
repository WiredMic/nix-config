;;; lang/openscad/doctor.el -*- lexical-binding: t; -*-

(unless (executable-find "openscad")
  (error! "Couldn't find openscad in your PATH"))

(assert! (or (not (modulep! +lsp))
             (modulep! :tools lsp))
         "This module requires (:tools lsp)")

(when (modulep! +lsp)
  (unless (executable-find "openscad-lsp")
    (warn! "Couldn't find openscad-lsp in your PATH")))

(when (and (modulep! :editor format)
           (not (modulep! +lsp)))
  (unless (executable-find "scadformat")
    (warn! "Couldn't find scadformat in your PATH")))
