;;; package --- Summary

;;; Commentary:

;;; Code:

;; Straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Straight with use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; general
(setq inhibit-startup-message t
      gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024))
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(desktop-save-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(set-face-attribute 'default nil :height 100)
(global-auto-revert-mode 1)

;; backups and locks
(setq create-lockfiles nil)
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; term colors
(use-package ansi-color
    :hook (compilation-filter . ansi-color-compilation-filter)) 

;; tree-sitter
(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
(use-package tree-sitter-langs)

;; folding
(use-package hideshow
  :hook  (prog-mode . hs-minor-mode)
  :bind
  (("C-c h t" . hs-toggle-hiding)
   ("C-c h b" . hs-hide-block)
   ("C-c h a" . hs-hide-all)
   ("C-c s b" . hs-show-block)
   ("C-c s a" . hs-show-all)))

;; compact modeline
(use-package minions
  :config (minions-mode +1))

;; themes
(use-package modus-themes
  :config (load-theme 'modus-operandi-tinted :no-confirm))

;; spell checker
(use-package flyspell
  :config
  (setq ispell-program-name "hunspell")
  :hook (text-mode . flyspell-mode))

;; expand region
(use-package expand-region
  :bind
  (("M-)" . er/expand-region)))

;; text jump
(use-package avy
  :bind
  (("C-c C-j" . avy-goto-char-2)))

(use-package ace-window
  :bind ("M-o" . ace-window))

;; ivy/counsel/swiper
(use-package counsel
  :init (ivy-mode)
  :config
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t)
  :bind* ; load when pressed
  (("M-x"     . counsel-M-x)
   ("C-s"     . swiper)
   ("C-x C-f" . counsel-find-file)
   ("C-x C-r" . counsel-recentf)  ; search for recently edited
   ("C-c g"   . counsel-git)      ; search for files in git repo
   ("C-c j"   . counsel-git-grep) ; search for regexp in git repo
   ("C-x l"   . counsel-locate)
   ("C-x C-f" . counsel-find-file)
   ("<f1> f"  . counsel-describe-function)
   ("<f1> v"  . counsel-describe-variable)
   ("<f1> l"  . counsel-find-library)
   ("<f2> i"  . counsel-info-lookup-symbol)
   ("<f2> u"  . counsel-unicode-char)
   ("C-c C-r" . ivy-resume)))

;; flycheck
(use-package flycheck
  :init (global-flycheck-mode)
  :bind
  (("C-c e p" . flycheck-previous-error)
   ("C-c e n" . flycheck-next-error)
   ("C-c e l" . flycheck-list-errors)))

(use-package which-key
  :init
  (which-key-mode))

(use-package lsp-mode
  :config
  (add-to-list 'lsp-file-watch-ignored-directories "\/build\/")
  (setq lsp-file-watch-threshold 10000
        lsp-rust-analyzer-cargo-watch-command "clippy"
        lsp-rust-analyzer-experimental-proc-attr-macros t
        lsp-rust-analyzer-proc-macro-enable t
        lsp-eldoc-render-all t
        lsp-idle-delay 0.6
        lsp-rust-analyzer-server-display-inlay-hints t)
  :bind
  (("M-?" . lsp-find-references)
   ("C-c l a" . lsp-execute-code-action)
   ("C-c l r" . lsp-rename)))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-doc-enable nil)
  :bind
  (("M-j" . lsp-ui-imenu)))

;; rust
(use-package rustic
  :after (lsp)
  :init (lsp-rust-analyzer-inlay-hints-mode)
  :config
  (setq rustic-format-on-save t
        lsp-rust-analyzer-cargo-watch-command "clippy"
        lsp-rust-analyzer-experimental-proc-attr-macros t
        lsp-rust-analyzer-proc-macro-enable t
        lsp-rust-analyzer-server-display-inlay-hints t))
(use-package toml-mode)

;; python
(use-package elpy
  :init
  (elpy-enable))

;; autocompletion
(use-package company
  :init (global-company-mode)
  :config (setq company-minimum-prefix-length 1
               company-idle-delay 0.0))

;; git
(use-package magit)
(use-package git-gutter
  :config
  (global-git-gutter-mode +1))

;; projectile
(use-package projectile
  :init (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map))

;; snippets
(use-package yasnippet
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))
(defun company-yasnippet-or-completion ()
  (interactive)
  (or (do-yas-expand)
      (company-complete-common)))
(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "::") t nil)))))
(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))
(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

;; treemacs
(use-package treemacs
  :bind ("M-0" . treemacs))
(use-package treemacs-magit
  :after (treemacs magit))
(use-package treemacs-projectile
  :after (treemacs projectile))

;; javascript
(use-package js2-mode
  :interpreter (("node" . js2-mode))
  :mode "\\.\\(js\\|json\\|cjs\\|mjs\\)$"
  :config
  (add-hook 'js-mode-hook 'js2-minor-mode)
  (setq js2-basic-offset 2
        js2-highlight-level 3
        js2-mode-show-parse-errors nil
        js2-mode-show-strict-warnings nil))
(use-package typescript-mode)
(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save))
  :bind
  (("C-c t r" . tide-rename-symbol)))

;; Custom
