;; (add-to-list 'load-path "~/Library/Slime/slime-2012-10-02/")
;; (add-to-list 'load-path ".")
;; (prefer-coding-system 'utf-8)
;; (setq slime-net-coding-system 'utf-8-unix)
;; (set-language-environment "UTF-8")
;; (setq slime-lisp-implementations
;;      '((sbcl ("sbcl") :coding-system utf-8-unix)))
;; (setq inferior-lisp-program "/usr/local/bin/sbcl")
;; (require 'slime-autoloads)
;; (slime-setup)

(show-paren-mode 1)
(column-number-mode 1)
(setq-default indent-tabs-mode nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq-default show-trailing-whitespace t)
(setq-default c-basic-offset 4)
;;(setq-default js-indent-level 2)
;;(setq-default js3-indent-level 2)
(setq-default js-indent-level 4)
(setq-default js3-indent-level 4)
(put 'downcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Fixing the keyboard for Mac OS X
(setq default-input-method "MacOSX")
(setq mac-option-modifier 'none)
(setq mac-command-key-is-meta 'none)

(set-default-font "-apple-Monaco-medium-normal-normal-*-10-*-*-*-m-0-iso10646-1")

(setq cider-lein-command "/usr/local/bin/lein")

(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; clojure-related stuff
(add-hook 'cide-moder-hook 'cider-turn-on-eldoc-mode)
(setq cider-popup-stacktraces nil)
(setq cider-repl-popup-stacktraces nil)
(setq cider-auto-select-error-buffer t)
(setq cider-repl-wrap-history t)
(setq cider-repl-history-size 1000)
(setq cider-repl-history-file "~/.cider-history")
(add-hook 'clojure-mode-hook #'smartparens-mode)

;; (setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

;; Don't show the splash screen
(setq inhibit-splash-screen t)

;; Do not store backup files in the working directories
(setq backup-directory-alist `(("." . "~/.saves")))
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)
(setq auto-save-file-name-transforms
      `((".*" ,"~/.saves" t)))

;; Bind unfill-region to meta-i.
(define-key global-map "\M-i" 'unfill-paragraph)

;; Previous window in ctrl-x p
(define-key global-map (kbd "C-x p")
  (lambda ()
    (interactive (other-window -1))))

(define-key global-map (kbd "C-x g") 'magit-status)
(define-key global-map (kbd "C-c g") 'magit-file-dispatch)

;; Save buffers on focus out
(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))

(define-key global-map "\M-c" 'compile)

;; Go
(defun my-go-mode-hook ()
  ;; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ;; Call gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           ;;           "go build -v && go test -v && go vet"))
           "go build -v && go vet"))
  ;; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (smartparens magit clojure-mode-extra-font-locking quack puppet-mode go-mode geiser clojure-test-mode cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
