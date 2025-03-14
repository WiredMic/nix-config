;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "mysty1"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("xparse" "") ("amsmath" "")))
   (TeX-run-style-hooks
    "xparse"
    "amsmath")
   (TeX-add-symbols
    '("pdv" ["argument"] 2)
    '("dv" ["argument"] 2)
    '("einheit" "Text")
    '("brac")
    '("bracket")
    '("ceil" 1)
    '("floor" 1)
    '("renewoperator" 3)
    '("newoperator" 3)
    "ohm"
    "bar"
    "micro"
    "degree"
    "celsius"
    "fahrenheit"
    "eu"
    "im"
    "varim"
    "imk"
    "ltag"
    "rtag"))
 :latex)

