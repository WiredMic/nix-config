;; -*- no-byte-compile: t; -*-
;;; lang/just/packages.el



(if (modulep! +tree-sitter)
    (package! just-ts-mode :pin "94f788eccb13cd3ade827af5612ffe3cad5fddf0")
  (package! just-mode :pin "b6173c7bf4d8d28e0dbd80fa41b9c75626885b4e"))
