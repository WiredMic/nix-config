;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "mysty4"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("xparse" "") ("amsmath" "")))
   (TeX-run-style-hooks
    "xparse"
    "amsmath")
   (TeX-add-symbols
    '("dpdv" ["argument"] 2)
    '("ddv" ["argument"] 2)
    '("pdv" ["argument"] 2)
    '("dv" ["argument"] 2)
    '("einheit" "Text")
    '("brac")
    '("bracket")
    '("ceil" 1)
    '("floor" 1)
    '("renewoperator" 3)
    '("newoperator" 3)
    "bar"
    "degree"
    "celsius"
    "fahrenheit"
    "eu"
    "im"
    "varim"
    "imj"
    "imk"
    "ltag"
    "rtag"))
 :latex)

