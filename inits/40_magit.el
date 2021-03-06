(require 'magit)
(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")

(global-set-key
 (kbd "C-x m")
 (defhydra my:hydra-magit (:exit t)
   "magit"
   ("s" magit-status "status")
   ("d" magit-diff-unstaged "diff")
   ("D" magit-diff-staged "diff cached")
   ("c" magit-commit "commit")
   ("l" magit-log "log")
   ("L" magit-log-long "log long")
   ("b" magit-branch-manager "branches")))
