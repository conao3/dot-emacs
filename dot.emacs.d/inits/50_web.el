;; INSTALL by package.el

(require 'web-mode)
;; (require 'tt)
;; (require 'xslate)

(add-to-list 'auto-mode-alist '("\\.html"  . web-mode))
(add-to-list 'auto-mode-alist '("\\.t[tx]" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ejs"   . web-mode))

(setq web-mode-html-offset 0)
(setq web-mode-css-offset 4)
(setq web-mode-script-offset 4)

(defun extension-match (ext)
  (string-match (concat "\\." ext "\\'") buffer-file-name))


;; zen-coding
;; install form package.el
(require 'zencoding-mode)
(setq zencoding-indentation 0)

(add-hook 'web-mode-hook
          '(lambda ()
             (zencoding-mode t)
             (local-set-key (kbd "C-c C-c") 'zencoding-expand-line)
             ;; (cond
             ;;  ((extension-match "tx")
             ;;   (xslate-mode t))
             ;;  ((extension-match "tt")
             ;;   (tt-mode t)))
             ))
