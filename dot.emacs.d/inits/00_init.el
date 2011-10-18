;; server
(server-start)

;; PATH
;; http://sakito.jp/emacs/emacsshell.html#path
(dolist (dir (list
              "/usr/X11/bin"
              "/sbin"
              "/usr/sbin"
              "/bin"
              "/usr/bin"
              "/usr/local/mysql/bin"
              "/Developer/Tools"
              "/usr/local/sbin"
              "/usr/local/bin"
              (expand-file-name "~/perl5/perlbrew/perls/current/bin")
              (expand-file-name "~/bin")))
  (when (and (file-exists-p dir) (not (member dir exec-path)))
    (print dir)
    (setenv "PATH" (concat dir ":" (getenv "PATH")))
    (setq exec-path (append (list dir) exec-path))))

;; mail address
(setq user-mail-address "nagata@handlena.me")

;; meta & super key
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; don't save backup files
(setq make-backup-files nil)

;; inhibit bell ring
(setq ring-bell-function 'ignore)

;; scroll settings
(setq scroll-step 1)

;; display column number
(column-number-mode t)

;; inhibit truncate
(setq-default truncate-lines nil)
(setq-default truncate-partial-width-windows t)

;; indent settings
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(c-set-offset 'case-label '+)

;; enable narrowing
(put 'narrow-to-region 'disabled nil)

;; hide startup message
(setq inhibit-startup-message t)

;; set time local
(setq system-time-locale "C")