(autoload 'php-mode "php-mode")
(require 'php-mode)
(setq php-mode-force-pear t)
(defun pear/php-mode-init()
  "Set some buffer-local variables."
  (setq case-fold-search t)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close 0))
(add-hook 'php-mode-hook 'pear/php-mode-init)

(add-hook 'php-mode-hook
          '(lambda ()
             (c-set-style "stroustrup")))
