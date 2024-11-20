;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "mysty"
 (lambda ()
   (TeX-add-symbols
    '("pdv" ["argument"] 2)
    '("dv" ["argument"] 2)
    '("evectors" "Text")
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

