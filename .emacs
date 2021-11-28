;; theme
(load-theme 'tango-dark t)
;;(load-file ".emacs-cedet.el")

;; misc
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(setq compilation-scroll-output t)
(setq-default c-basic-offset 2)

(custom-set-variables '(package-selected-packages '(eglot)))
(custom-set-faces )
(require 'eglot)
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd-9" "-log=verbose"))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
