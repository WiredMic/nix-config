;; -*- no-byte-compile: t; -*-
;;; lang/typst/packages.el

;; https://codeberg.org/meow_king/typst-ts-mode
(package! typst-ts-mode
  :recipe (:pre-build
           (("sed" "-i"
             "s/;;;###autoload$/;;;###autoload (autoload 'typst-ts-compilation-mode \"typst-ts-compile\" nil t)/"
             "typst-ts-compile.el"))))
