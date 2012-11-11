;; INSTALL
;; (auto-install-batch "anithing")
;; (install-elisp "http://svn.coderepos.org/share/lang/elisp/anything-c-moccur/trunk/anything-c-moccur.el")
;; (install-elisp-from-emacswiki "anything-etags.el")
;; (install-elisp-from-emacswiki "anything-gtags.el")

(require 'anything-config)

;; Incremental search for current buffer
;; http://d.hatena.ne.jp/IMAKADO/20080724/1216882563
;; INSTALL
;; (install-elisp-from-emacs-wiki "color-moccur.el")
;; (install-elisp "http://svn.coderepos.org/share/lang/elisp/anything-c-moccur/trunk/anything-c-moccur.el")
(require 'color-moccur)
(require 'anything-c-moccur)
(setq moccur-split-word t)
(defadvice moccur-edit-change-file
  (after save-after-moccur-edit-buffer activate)
  (save-buffer))
(setq anything-c-moccur-anything-idle-delay 0.2
      anything-c-moccur-enable-initial-pattern nil
      anything-c-moccur-higligt-info-line-flag t
      anything-c-moccur-enable-auto-look-flag t)
(define-key global-map (kbd "C-s") 'anything-c-moccur-occur-by-moccur)
(define-key global-map (kbd "C-S-s") 'anything-c-moccur-dmoccur)

;; for files and buffers
(define-key global-map (kbd "C-x b") 'anything-for-files)

;; killring history
(define-key global-map (kbd "C-M-y") 'anything-show-kill-ring)

;; imenu
(define-key global-map (kbd "C-x i") 'anything-imenu)

;; emacs commands
(define-key global-map (kbd "M-x")
  (lambda ()
    "Execute emacs commands in anything"
    (interactive)
    (anything '(anything-c-source-emacs-commands))))

;; tag jump
(require 'anything-etags)
(require 'anything-gtags)
(define-key global-map (kbd "C-x t")
  (lambda ()
    "Tag jump using etags, gtags and `anything'."
    (interactive)
    (let* ((initial-pattern (regexp-quote (or (thing-at-point 'symbol) ""))))
      (anything (list anything-c-source-gtags-select
                      anything-c-source-etags-select))
      "Find Tag: " nil)))

;; bookmark
(define-key global-map (kbd "C-x r l")
  (lambda ()
    "List bookmarks in anything"
    (interactive)
    (anything '(anything-c-source-bookmarks))))

;; anything-project
;; INSTALL
;; (install-elisp "https://github.com/imakado/anything-project/raw/master/anything-project.el")
(require 'anything-project)
(global-set-key (kbd "C-c b") 'anything-project)
(ap:add-project
 :name 'perl
 :look-for '("Makefile.PL" "Build.PL")
 :include-regexp '("\\.pm$" "\\.t$" "\\.pl$" "\\.PL$" "\\.mt$" "\\.tt$" "\\.tx$")
 :exclude-regexp '("/tmp" "/service")
 )

(ap:add-project
 :name 'symfony
 :look-for '("symfony")
 :include-regexp '("\\.php$" "\\.html" "\\.yml$" "\\.base$" "\\.txt$")
 :exclude-regexp '("/cache" "/log" ".*/vendor" ".*/sf")
 )

;; file cache for anything-project
;; http://d.hatena.ne.jp/kitokitoki/20110710/p1
(defvar ap:project-files ".ap-project-files")

(defadvice anything-project (around anything-project-by-file-cache activate)
  (interactive)
  (anything-project-init)
  (anything-other-buffer
   `(((name . "Project Files in File Cache")
      (candidates-file . ,(ap:get-project-root-path))
      (action . (("Find file" .
                  (lambda (c)
                    (find-file (ap:expand-file c))))
                 ("Find file other window" .
                  (lambda (c)
                    (find-file-other-window (ap:expand-file c))))
                 ("Find file other frame" .
                  (lambda (c)
                    (find-file-other-frame (ap:expand-file c))))
                 ("Open dired in file's directory" .
                  (lambda (c)
                    (ap:anything-c-open-dired (ap:expand-file c))))))))
   "*anything project in file cache*"))

(defun ap:make-cache-file ()
  (interactive)
  (with-temp-buffer
    (insert (mapconcat 'identity (ap:get-project-files) "\n"))
    (write-file (ap:get-project-root-path))))

(defun ap:get-project-root-path ()
  (ap:aif (car (ap:get-root-directory))
      (concat it ap:project-files)
     nil))

(defun anything-project-init ()
  (ap:set-project-root-path)
  (when (or current-prefix-arg (not (ap:project-files-p)))
     (ap:make-cache-file)))

(defun ap:set-project-root-path ()
  (setq ap:root-directory (car (ap:get-root-directory))))

(defmacro ap:aif (test-form then-form &optional else-form)
  `(let ((it ,test-form))
     (if it ,then-form ,else-form)))

(defun ap:project-files-p ()
  (file-exists-p (ap:get-project-root-path)))

;; anything-git-project
;; http://qiita.com/items/2940
(defun anything-c-sources-git-project-for (pwd)
  (loop for elt in
        '(("Modified files (%s)" . "--modified")
          ("Untracked files (%s)" . "--others --exclude-standard")
          ("All controlled files in this project (%s)" . ""))
        collect
        `((name . ,(format (car elt) pwd))
          (init . (lambda ()
                    (unless (and ,(string= (cdr elt) "") ;update candidate buffer every time except for that of all project files
                                 (anything-candidate-buffer))
                      (with-current-buffer
                          (anything-candidate-buffer 'global)
                        (insert
                         (shell-command-to-string
                          ,(format "git ls-files $(git rev-parse --show-cdup) %s"
                                   (cdr elt))))))))
          (candidates-in-buffer)
          (type . file))))

(defun anything-git-project ()
  (interactive)
  (let* ((pwd (shell-command-to-string "echo -n `pwd`"))
         (sources (anything-c-sources-git-project-for pwd)))
    (anything-other-buffer sources
     (format "*Anything git project in %s*" pwd))))
(define-key global-map (kbd "C-c g") 'anything-git-project)
