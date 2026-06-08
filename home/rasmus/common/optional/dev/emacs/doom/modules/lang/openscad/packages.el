;;; lang/openscad/packages.el -*- lexical-binding: t; -*-


(if (modulep! +tree-sitter)
    ()
  (package! scad-mode :pin "8798dca7e919705bcbc35d4ab5639556827ccb6f"))
