
(load-file "~/.emacs.d/sensible-defaults.el/sensible-defaults.el")
(sensible-defaults/use-all-settings)
(sensible-defaults/use-all-keybindings)

(setq user-full-name "Oskar Strömberg"
      user-mail-address "oskstr@kth.se"
      calendar-latitude 59.3
      calendar-longitude 18.1
      calendar-location-name "Stockholm, Sweden")

(package-initialize)
(require 'package)
(add-to-list 'package-archives
           '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
;; For important compatibility libraries like cl-lib
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(tool-bar-mode 0)
(menu-bar-mode 0)
(when window-system
  (scroll-bar-mode -1))
(blink-cursor-mode nil)

(global-prettify-symbols-mode t)

(when window-system
  (load-theme 'atom-one-dark t))

(setq ring-bell-function 'ignore)

(setq hrs/default-font "Ubuntu Mono")
(setq hrs/default-font-size 18)
(setq hrs/current-font-size hrs/default-font-size)

(setq hrs/font-change-increment 1.1)

(defun hrs/set-font-size ()
  "Set the font to `hrs/default-font' at `hrs/current-font-size'."
  (set-frame-font
   (concat hrs/default-font "-" (number-to-string hrs/current-font-size))))

(defun hrs/reset-font-size ()
  "Change font size back to `hrs/default-font-size'."
  (interactive)
  (setq hrs/current-font-size hrs/default-font-size)
  (hrs/set-font-size))

(defun hrs/increase-font-size ()
  "Increase current font size by a factor of `hrs/font-change-increment'."
  (interactive)
  (setq hrs/current-font-size
        (ceiling (* hrs/current-font-size hrs/font-change-increment)))
  (hrs/set-font-size))

(defun hrs/decrease-font-size ()
  "Decrease current font size by a factor of `hrs/font-change-increment', down to a minimum size of 1."
  (interactive)
  (setq hrs/current-font-size
        (max 1
             (floor (/ hrs/current-font-size hrs/font-change-increment))))
  (hrs/set-font-size))

(define-key global-map (kbd "C-)") 'hrs/reset-font-size)
(define-key global-map (kbd "C-+") 'hrs/increase-font-size)
(define-key global-map (kbd "C-=") 'hrs/increase-font-size)
(define-key global-map (kbd "C-_") 'hrs/decrease-font-size)
(define-key global-map (kbd "C--") 'hrs/decrease-font-size)

(hrs/reset-font-size)

(when window-system
  (global-hl-line-mode))

(with-eval-after-load 'org
  (add-hook 'org-mode-hook
            (lambda ()
              (org-bullets-mode t))))

(with-eval-after-load 'org
  (setq org-ellipsis "⤵"))

(with-eval-after-load 'org
  (setq org-src-fontify-natively t))

(with-eval-after-load 'org
  (setq org-src-tab-acts-natively t))

(with-eval-after-load 'org
  (setq org-src-window-setup 'current-window))

(with-eval-after-load 'org
  (setq org-directory "~/org")

  (defun org-file-path (filename)
    "Return the absolute address of an org file, given its relative name."
    (concat (file-name-as-directory org-directory) filename))

  (setq org-index-file (org-file-path "index.org"))
  (setq org-archive-location
        (concat (org-file-path "archive.org") "::* From %s")))

(with-eval-after-load 'org
  (setq org-agenda-files (list org-index-file)))

(with-eval-after-load 'org
  (defun mark-done-and-archive ()
    "Mark the state of an org-mode item as DONE and archive it."
    (interactive)
    (org-todo 'done)
    (org-archive-subtree))

  (define-key global-map "\C-c\C-x\C-s" 'mark-done-and-archive))

(with-eval-after-load 'org
  (setq org-log-done 'time))

(setq org-capture-templates
      '(("b" "Blog idea"
         entry
         (file (org-file-path "blog-ideas.org"))
         "* TODO %?\n")

        ("g" "Groceries"
         checkitem
         (file (org-file-path "groceries.org")))

        ("l" "Today I Learned..."
         entry
         (file+datetree (org-file-path "til.org"))
         "* %?\n")

        ("r" "Reading"
         checkitem
         (file (org-file-path "to-read.org")))

        ("t" "Todo"
         entry
         (file org-index-file)
         "* TODO %?\n")))

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

(defun open-index-file ()
  "Open the master org TODO list."
  (interactive)
  (hrs/copy-tasks-from-inbox)
  (find-file org-index-file)
  (flycheck-mode -1)
  (end-of-buffer))

(global-set-key (kbd "C-c i") 'open-index-file)

(defun org-capture-todo ()
  (interactive)
  (org-capture :keys "t"))

(global-set-key (kbd "M-n") 'org-capture-todo)
(add-hook 'gfm-mode-hook
          (lambda () (local-set-key (kbd "M-n") 'org-capture-todo)))
(add-hook 'haskell-mode-hook
          (lambda () (local-set-key (kbd "M-n") 'org-capture-todo)))

(with-eval-after-load 'org
  (require 'ox-md)
  (require 'ox-beamer)
  (require 'ox-twbs)
)

(with-eval-after-load 'org
(org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (gnuplot . t))))

(with-eval-after-load 'org
  (setq org-confirm-babel-evaluate nil))

(with-eval-after-load 'org
 (setq org-export-with-smart-quotes t))

(with-eval-after-load 'org
 (setq org-html-postamble nil))

(with-eval-after-load 'org
  (setq org-latex-pdf-process
        '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f")))

(with-eval-after-load 'org
  (add-to-list 'org-latex-packages-alist '("" "minted"))
  (setq org-latex-listings 'minted))

(with-eval-after-load 'org
  (setq TeX-parse-self t))

(with-eval-after-load 'org
  (setq TeX-PDF-mode t))

(with-eval-after-load 'org
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (LaTeX-math-mode)
              (setq TeX-master t))))

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(ido-ubiquitous)
(flx-ido-mode 1) ; better/faster matching
(setq ido-create-new-buffer 'always) ; don't confirm to create new buffers
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
