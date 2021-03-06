;; theme
(load-theme 'tango-dark t)

;; misc
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(setq compilation-scroll-output t)
(setq-default c-basic-offset 4)

(load-file "emacs-mods/lsp-mod.el")
(load-file "emacs-mods/cmake-mod.el")

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

;(add-hook 'lsp-after-open-hook #'lsp-origami-try-enable)
