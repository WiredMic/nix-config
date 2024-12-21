;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "personal"
 (lambda ()
   (TeX-add-symbols
    '("pderiv" ["argument"] 2)
    '("deriv" ["argument"] 2)
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
    "varim"))
 :latex)

