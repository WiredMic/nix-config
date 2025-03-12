;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "mysty6"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("xparse" "") ("amsmath" "") ("amssymb" "")))
   (TeX-run-style-hooks
    "xparse"
    "amsmath"
    "amssymb")
   (TeX-add-symbols
    '("einheit" "Text")
    '("brac")
    '("bracket")
    '("trivec" 1)
    '("bivec" 1)
    '("ceil" 1)
    '("floor" 1)
    '("renewoperator" 3)
    '("newoperator" 3)
    "eu"
    "im"
    "varim"
    "imj"
    "imk"
    "ltag"
    "rtag"))
 :latex)

