;;; lang/typst/config.el -*- lexical-binding: t; -*-
;; https://myriad-dreamin.github.io/tinymist/frontend/emacs.html
;; https://github.com/emacs-lsp/lsp-mode/blob/master/clients/lsp-typst.el


;; TODO formatter

(defgroup doom-typst nil
  "Typst language support for Doom Emacs."
  :group 'languages
  :group 'programming)

(defcustom +typst-lsp-server-path nil
  "Path to binary server file."
  :group 'doom-typst
  :risky t
  :type 'file)

(defun +typst-lsp-config ()
  (when (modulep! +lsp)
    (message "Running LSP config")
    (if (modulep! :tools lsp -eglot)

        (progn
          (after! lsp-mode
            (require 'lsp-typst)
            (when +typst-lsp-server-path
              (setq lsp-typst-server-command (list +typst-lsp-server-path)))
            (set-lsp-priority! 'tinymist 0)))
      ;; (after! lsp-mode
      ;;   (require 'lsp-typst)
      
      ;;   ;; We need to override the client registration to add initializationOptions
      ;;   (lsp-register-client
      ;;    (make-lsp-client
      ;;     :new-connection (lsp-stdio-connection
      ;;                      (lambda ()
      ;;                        (or (when +typst-lsp-server-path
      ;;                              (list +typst-lsp-server-path))
      ;;                            lsp-typst-server-command)))
      ;;     :activation-fn (lsp-activate-on "typst")
      ;;     :server-id 'tinymist
      ;;     :priority 0
      ;;     :initialization-options
      ;;     (lambda ()
      ;;       (ht ("projectResolution" (or lsp-typst-project-resolution "lockDatabase"))
      ;;           ("formatterMode" (or lsp-typst-formatter-mode "typstyle"))
      ;;           ("formatterIndentSize" (or lsp-typst-formatter-indent-size 2))
      ;;           ("formatterPrintWidth" (or lsp-typst-formatter-print-width 120))
      ;;           ("exportPdf" (or lsp-typst-export-pdf "never"))
      ;;           ("exportTarget" (or lsp-typst-export-target "paged"))
      ;;           ("outputPath" (or lsp-typst-output-path ""))
      ;;           ("systemFonts" (if lsp-typst-system-fonts t :json-false))
      ;;           ("semanticTokens" (if lsp-typst-semantic-tokens "enable" "disable"))))
      ;;     :initialized-fn (lambda (workspace)
      ;;                       (with-lsp-workspace workspace
      ;;                         (lsp--set-configuration
      ;;                          (lsp-configuration-section "tinymist"))))
      ;;     :synchronize-sections '("tinymist"))))


      
      (after! eglot
        (set-eglot-client! 'typst-ts-mode
                           (lambda (&rest _)
                             (let  ((server-path (or +typst-lsp-server-path "tinymist")))
                               (list server-path))))))))


(use-package! typst-ts-mode
  :when (modulep! +tree-sitter)
  :mode "\\.typ\\'"
  :init
  (set-tree-sitter! nil 'typst-ts-mode
    '((typst :url "https://github.com/uben0/tree-sitter-typst"
       :commit "13863ddcbaa7b68ee6221cea2e3143415e64aea4")))
  :hook (typst-ts-mode . (lambda () (when (modulep! +lsp) (lsp!))))
  :config
  (+typst-lsp-config))
