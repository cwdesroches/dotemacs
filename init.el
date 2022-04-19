;; Emacs Config

;; Current file setup:
;; - initial setup
;; - look and feel
;; - file management
;; - language config


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.

 '(package-selected-packages '(ivy-rich which-key command-log-mode use-package)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq inhibit-startup-message t)
(setq backup-directory-alist '((".*" . "~/Homebase/.backups/emacs")))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(menu-bar-mode -1)

(set-face-attribute 'default nil :font "Monospace" :height 140)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package command-log-mode)

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config (ivy-mode 1)
  :init (ivy-mode 1))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 18)))

(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :init (ivy-rich-mode 1))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Homebase/dev/dev-src/local")
    (setq projectile-project-search-path '("~/Homebase/dev/dev-src/local")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package general
  :config
  (general-create-definer cwdesroches/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (cwdesroches/leader-keys
   "t" '(:ignore t :which-key "toggles")
   "tt" '(counsel-load-theme :which-key "choose theme")))

(general-define-key
 "C-M-j" 'counsel-switch-buffer)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(cwdesroches/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale-text"))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit)

(use-package org)
  
;; Clojure Related Configuration

(use-package clojure-mode)

(use-package cider)

(use-package lsp-treemacs)

(use-package flycheck)

(use-package company)

(use-package lsp-mode
  :hook ((clojure-mode . lsp)
	 (clojurescript-mode . lsp)
	 (clojurec-mode . lsp))
  :commands lsp
  :config
  (setq ; recommended
   gc-cons-threshold (* 100 1024 1024)
   read-process-output-max (* 1024 1024))

  (setq ; optional
   lsp-lens-enable t
   lsp-semantic-tokens-enable t 
   cljr-add-ns-to-blank-clj-files nil
   cider-eldoc-display-for-symbol-at-point nil))

