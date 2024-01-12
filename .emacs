(show-paren-mode 1)
(column-number-mode 1)
(setq-default indent-tabs-mode nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq-default show-trailing-whitespace t)
(setq-default c-basic-offset 4)
(setq-default js-indent-level 2)
(setq-default js3-indent-level 2)
(put 'downcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Fixing the keyboard for Mac OS X
(setq default-input-method "MacOSX")
(setq mac-option-modifier 'none)
(setq mac-command-key-is-meta 'none)

(when (member "Monaco" (font-family-list))
  (set-frame-font "Monaco-10" t t))
(when (member "DejaVu Sans Mono" (font-family-list))
  (set-frame-font "DejaVu Sans Mono-10" t t))

(setq cider-lein-command "/usr/local/bin/lein")

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; clojure-related stuff
(add-hook 'cider-moder-hook 'cider-turn-on-eldoc-mode)
(setq cider-popup-stacktraces nil)
(setq cider-repl-popup-stacktraces nil)
(setq cider-auto-select-error-buffer t)
(setq cider-repl-wrap-history t)
(setq cider-repl-history-size 1000)
(setq cider-repl-history-file "~/.cider-history")
(add-hook 'clojure-mode-hook #'smartparens-strict-mode)
(eval-after-load "smartparens"
  '(progn
     (define-key smartparens-mode-map (kbd "C-c f") 'sp-forward-slurp-sexp)
     (define-key smartparens-mode-map (kbd "C-c b") 'sp-backward-slurp-sexp)
     (define-key smartparens-mode-map (kbd "C-c (") 'sp-wrap-round)
     (define-key smartparens-mode-map (kbd "C-c )") 'sp-unwrap-sexp)))

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

;; Unmap zoom by mouse wheel
(define-key global-map (vector (list 'control mouse-wheel-down-event)) nil)
(define-key global-map (vector (list 'control mouse-wheel-up-event)) nil)

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

;; Typescript with tide
(defun setup-tide-mode ()
  (setq typescript-indent-level 2)
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1)
  ;; Use prettier-js to format with prettier.
  (prettier-js-mode)
  (eval-after-load "tide"
    '(progn
       (define-key tide-mode-map (kbd "C-c o") 'tide-organize-imports)
       (define-key tide-mode-map (kbd "C-c r") 'tide-rename-symbol)
       (flycheck-add-mode 'typescript-tslint 'web-mode))))

;; Tide for TSX
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (or (string-equal "tsx" (file-name-extension buffer-file-name))
                      (string-equal "jsx" (file-name-extension buffer-file-name)))
              (setup-tide-mode))))

;; Tweaks for web-mode
(setq web-mode-enable-auto-quoting nil)

;; Swift with sourcekit-lsp
;;(eval-after-load 'lsp-mode
;;  (progn
;;    (require 'lsp-sourcekit)
;;    (setq lsp-sourcekit-executable
;;          "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp")))
;;(add-hook 'swift-mode-hook (lambda () (lsp)))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
;; (add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; Blink mode line instead of an audible bell.
(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-foreground 'mode-line)))
          (set-face-foreground 'mode-line "#F2804F")
          (run-with-idle-timer 0.1 nil
                               (lambda (fg) (set-face-foreground 'mode-line fg))
                               orig-fg))))

;; Rusty stuff
(defun setup-rust-mode ()
  (setq rust-format-on-save t)
  (lsp-deferred)
  (define-key rust-mode-map (kbd "C-c r") 'lsp-rename))

(require 'rust-mode)
(require 'lsp-mode)
(add-hook 'rust-mode-hook 'setup-rust-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(show-paren-mode t))

(setq package-selected-packages
 '(rust-mode web-mode swift-mode lsp-sourcekit yaml-mode markdown-mode markdown-preview-eww markdown-preview-mode prettier-js company tide clojurescript-mode clojure-mode smartparens magit clojure-mode-extra-font-locking quack puppet-mode go-mode geiser clojure-test-mode cider))

;; Important utility, reverse text in region.
(defun my-reverse-region (beg end)
 "Reverse characters between BEG and END."
 (interactive "r")
 (let ((region (buffer-substring beg end)))
   (delete-region beg end)
   (insert (nreverse region))))

;; Adjust Magit's logic of opening windows

;; Increase and decrease font size
(defun set-font-size (font-size)
  (interactive "nFont size: ")
  (set-face-attribute 'default nil :height (* font-size 10)))

(defun get-font-size ()
   (let ((font-size (cdr (assoc :height (face-all-attributes 'default)))))
     (if (eq font-size 'unspecified)
         10
       (/ font-size 10))))

(defun increase-default-font-size ()
  (interactive)
   (set-font-size (+ (get-font-size) 2)))

(defun decrease-default-font-size ()
  (interactive)
   (set-font-size (- (get-font-size) 2)))

(define-key global-map (kbd "M-U") 'increase-default-font-size)
(define-key global-map (kbd "M-u") 'decrease-default-font-size)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
