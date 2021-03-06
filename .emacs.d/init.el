;; Name and Email
(setq user-full-name "Rikuhiro Kojima")
(setq user-mail-address "rikuhiro6@gmail.com")

;;Full Screen
;; (set-frame-parameter nil 'fullscreen 'fullboth)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; PATH
;;; load-path の設定
;;
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-loadpath)
	                (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path
 "config"
 )

(setenv "MANPATH" (concat "/usr/local/man:/usr/share/man:/Developer/usr/share/man:/sw/share/man" (getenv "MANPATH")))

;;
;;Basical Setting
;;

;; Disappear startup message
(setq inhibit-startup-screen t)

;; rename yes/no y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; Language code
;; export LANG=ja_JP.UTF-8
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;;Default Font
(add-to-list 'default-frame-alist '(font . "ricty-13.5"))
(add-to-list 'default-frame-alist '(font . "Ricty Diminished Discord-15"))

;;No display tool-bar
(tool-bar-mode 0)

;; Set Metakey
(when (eq system-type 'darwin)
  (setq ns-command-modifier (quote meta)))

;; Linum
(setq linum-format "%2d ")
(global-linum-mode t)

;;
;; Key Setting
;;

;; Undo
(global-set-key "\C-z" 'undo)

;; Kill buffer
(global-set-key (kbd "C-:") 'kill-this-buffer)

;; Truncate
(global-set-key (kbd "C-x t") 'toggle-truncate-lines)

;; Reload buffer
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive) (revert-buffer t t))

(global-set-key (kbd "\M-r") 'revert-buffer-no-confirm)

(global-auto-revert-mode 1)

;;
;; Advanced Setting
;;

;; Ruby
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(add-to-list 'auto-mode-alist '("\\.rb$latex " . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))

;; Ruby-electric
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
(setq ruby-electric-expand-delimiters-list nil)

;; Ruby-block
;; ruby-block.el --- highlight matching block
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)

;;SmartCompile for Ruby
(require 'smart-compile)
(define-key ruby-mode-map (kbd "C-c c") 'smart-compile)
(define-key ruby-mode-map (kbd "C-c C-c") (kbd "C-c c C-m"))

;; Auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
;(setq ac-auto-start nil)
(ac-set-trigger-key "TAB") 

;; Auto-complete-clan
(require 'auto-complete-clang)
(setq clang-completion-suppress-error 't)

(defun my-c-mode-common-hook()
  (setq ac-auto-start nil)
  (setq ac-expand-on-auto-complete nil)
  (setq ac-quick-help-delay 0.3)
  (define-key c-mode-base-map (kbd "M-/") 'ac-complete-clang)
)

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;
;; PATH
;;
(setenv "PATH"
	(concat (getenv "PATH") ":/usr/texbin"))

;;
;; TeX mode
;;
(setq auto-mode-alist
      (append '(("\\.tex$" . latex-mode)) auto-mode-alist))
(setq tex-default-mode 'latex-mode)
(setq tex-start-commands "\\nonstopmode\\input")
(setq tex-run-command "/usr/texbin/ptex2pdf -u -e -ot '-synctex=1 -interaction=nonstopmode'")
					;(setq tex-run-command "/usr/texbin/luatex -synctex=1 -interaction=nonstopmode")
					;(setq tex-run-command "/usr/texbin/luajittex -synctex=1 -interaction=nonstopmode")
					;(setq tex-run-command "/usr/texbin/xetex -synctex=1 -interaction=nonstopmode")
					;(setq tex-run-command "/usr/texbin/pdftex -synctex=1 -interaction=nonstopmode")
(setq latex-run-command "/usr/texbin/ptex2pdf -u -l -ot '-synctex=1 -interaction=nonstopmode'")
					;(setq latex-run-command "/usr/texbin/lualatex -synctex=1 -interaction=nonstopmode")
					;(setq latex-run-command "/usr/texbin/luajitlatex -synctex=1 -interaction=nonstopmode")
					;(setq latex-run-command "/usr/texbin/xelatex -synctex=1 -interaction=nonstopmode")
					;(setq latex-run-command "/usr/texbin/pdflatex -synctex=1 -interaction=nonstopmode")
(setq tex-bibtex-command "/usr/texbin/latexmk -e '$latex=q/uplatex %O -synctex=1 -interaction=nonstopmode %S/' -e '$bibtex=q/upbibtex %O %B/' -e '$biber=q/biber %O --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex %O -o %D %S/' -e '$dvipdf=q/dvipdfmx %O -o %D %S/' -norc -gg -pdfdvi")
(require 'tex-mode)
(defun tex-view ()
  (interactive)
  (tex-send-command "/usr/bin/open -a Skim.app" (tex-append tex-print-file ".pdf")))
(defun tex-print (&optional alt)
  (interactive "P")
  (if (tex-shell-running)
      (tex-kill-job)
    (tex-start-shell))
  (tex-send-command "/usr/bin/open -a \"Adobe Reader.app\"" (tex-append tex-print-file ".pdf")))
(setq tex-compile-commands
      '(("/usr/texbin/ptex2pdf -u -l -ot '-synctex=1 -interaction=nonstopmode' %f" "%f" "%r.pdf")
	("/usr/texbin/uplatex -synctex=1 -interaction=nonstopmode %f && /usr/texbin/dvips -Ppdf -z -f %r.dvi | /usr/texbin/convbkmk -u > %r.ps && /usr/local/bin/ps2pdf %r.ps" "%f" "%r.pdf")
	("/usr/texbin/pdflatex -synctex=1 -interaction=nonstopmode %f" "%f" "%r.pdf")
	("/usr/texbin/lualatex -synctex=1 -interaction=nonstopmode %f" "%f" "%r.pdf")
	("/usr/texbin/luajitlatex -synctex=1 -interaction=nonstopmode %f" "%f" "%r.pdf")
	("/usr/texbin/xelatex -synctex=1 -interaction=nonstopmode %f" "%f" "%r.pdf")
	("/usr/texbin/latexmk %f" "%f" "%r.pdf")
	("/usr/texbin/latexmk -e '$latex=q/uplatex %%O -synctex=1 -interaction=nonstopmode %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -e '$dvipdf=q/dvipdfmx %%O -o %%D %%S/' -norc -gg -pdfdvi %f" "%f" "%r.pdf")
	("/usr/texbin/latexmk -e '$latex=q/uplatex %%O -synctex=1 -interaction=nonstopmode %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -e '$dvips=q/dvips %%O -z -f %%S | convbkmk -u > %%D/' -e '$ps2pdf=q/ps2pdf %%O %%S %%D/' -norc -gg -pdfps %f" "%f" "%r.pdf")
	("/usr/texbin/latexmk -e '$pdflatex=q/pdflatex %%O -synctex=1 -interaction=nonstopmode %%S/' -e '$bibtex=q/bibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/makeindex %%O -o %%D %%S/' -norc -gg -pdf %f" "%f" "%r.pdf")
	("/usr/texbin/latexmk -e '$pdflatex=q/lualatex %%O -synctex=1 -interaction=nonstopmode %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %f" "%f" "%r.pdf")
	("/usr/texbin/latexmk -e '$pdflatex=q/luajitlatex %%O -synctex=1 -interaction=nonstopmode %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %f" "%f" "%r.pdf")
	("/usr/texbin/latexmk -e '$pdflatex=q/xelatex %%O -synctex=1 -interaction=nonstopmode %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %f" "%f" "%r.pdf")
	((concat "\\doc-view" " \"" (car (split-string (format "%s" (tex-main-file)) "\\.")) ".pdf\"") "%r.pdf")
	("/usr/bin/open -a Skim.app %r.pdf" "%r.pdf")
	("/usr/bin/open -a Preview.app %r.pdf" "%r.pdf")
	("/usr/bin/open -a TeXShop.app %r.pdf" "%r.pdf")
	("/Applications/TeXworks.app/Contents/MacOS/TeXworks %r.pdf" "%r.pdf")
	("/Applications/texstudio.app/Contents/MacOS/texstudio --pdf-viewer-only %r.pdf" "%r.pdf")
	("/usr/bin/open -a Firefox.app %r.pdf" "%r.pdf")
	("/usr/bin/open -a \"Adobe Reader.app\" %r.pdf" "%r.pdf")))

(defun skim-forward-search ()
  (interactive)
  (let* ((ctf (buffer-name))
	 (mtf (tex-main-file))
	 (pf (concat (car (split-string mtf "\\.")) ".pdf"))
	 (ln (format "%d" (line-number-at-pos)))
	 (cmd "/Applications/Skim.app/Contents/SharedSupport/displayline")
	 (args (concat ln " " pf " " ctf)))
    (message (concat cmd " " args))
    (process-kill-without-query
     (start-process-shell-command "displayline" nil cmd args))))

(add-hook 'latex-mode-hook
	  '(lambda ()
	     (define-key latex-mode-map (kbd "C-c s") 'skim-forward-search)))

;;
;; RefTeX with TeX mode
;;
(add-hook 'latex-mode-hook 'turn-on-reftex)

;; Multi-term
(require 'multi-term)
(add-to-list 'term-unbind-key-list '"M-x")
(setq multi-term-program shell-file-name)
(add-hook 'term-mode-hook
	  '(lambda ()
	     ;; C-h を term 内文字削除にする
	     (define-key term-raw-map (kbd "C-h") 'term-send-backspace)
	     ;; C-y を term 内ペーストにする
	     (define-key term-raw-map (kbd "C-y") 'term-paste)
	     ))

(global-set-key (kbd "C-c t") '(lambda ()
				 (interactive)
				 (multi-term)))
				;(setq system-uses-terminfo nil)
; Move Buf
(global-set-key (kbd "C-c n") 'multi-term-next)
(global-set-key (kbd "C-c p") 'multi-term-prev)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(current-language-environment "Japanese")
 '(debug-on-error t)
 '(debug-on-quit t)
 '(org-agenda-files (quote ("~/Documents/myproduct/org/test.org")))
 '(package-selected-packages
   (quote
    (haskell-mode multishell pyvirtualenv virtualenv jedi multi-term tern-auto-complete slime-repl quickrun powerline org-tree-slide org-plus-contrib org markdown-mode latex-math-preview js2-mode jack-connect ix emoji-fontset)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-empty ((t (:background "Green" :foreground "controlDarkShadowColor" :underline t))))
 '(whitespace-line ((t nil)))
 '(whitespace-space ((t (:foreground "controlShadowColor" :underline t))))
 '(whitespace-tab ((t (:background "beige" :underline t))))
 '(whitespace-trailing ((t (:background "Red" :foreground "Magenta" :underline t :weight bold)))))

;;Powerline
;; ;; (require 'powerline)
;; (set-face-attribute 'mode-line nil
;;                     :foreground "#fff"
;;                     :background "#FF0000"
;;                     :box nil)

;; (set-face-attribute 'powerline-active1 nil
;;                     :foreground "#fff"
;;                     :background "#00BFBB"
;;                     :inherit 'mode-line)

;; (set-face-attribute 'powerline-active2 nil
;;                     :foreground "#000"
;;                     :background "#87CEEB"
;;                     :inherit 'mode-line)
;; (powerline-default-theme)

;ac-mode
;(require 'ac-mode)

;change-buffer
(if window-system (require 'change-buffer))

;;proverif
(setq auto-mode-alist
      (cons '("\\.horn$" . proverif-horn-mode)
	    (cons '("\\.horntype$" . proverif-horntype-mode)
		  (cons '("\\.pv$" . proverif-pv-mode)
			(cons '("\\.pi$" . proverif-pi-mode) auto-mode-alist)))))
(autoload 'proverif-pv-mode "proverif" "Major mode for editing ProVerif code." t)
(autoload 'proverif-pi-mode "proverif" "Major mode for editing ProVerif code." t)
(autoload 'proverif-horn-mode "proverif" "Major mode for editing ProVerif code." t)
(autoload 'proverif-horntype-mode "proverif" "Major mode for editing ProVerif code." t)

;;Disappear scratch and message
(setq initial-scratch-message "")
(setq inhibit-startup-message t)


;;For C/C++
(add-hook 'c-mode-common-hook
          '(lambda ()
             ;; センテンスの終了である ';' を入力したら、自動改行+インデント
             ;;(c-toggle-auto-hungry-state 1)
             ;; RET キーで自動改行+インデント
             (define-key c-mode-base-map "\C-m" 'newline-and-indent)
	     ))

;;gtags-mode
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-t" 'gtags-find-tag)
         (local-set-key "\M-r" 'gtags-find-rtag)
         (local-set-key "\M-s" 'gtags-find-symbol)
         (local-set-key "\C-t" 'gtags-pop-stack)
         ))
(add-hook 'c-mode-common-hook
          '(lambda()
             (gtags-mode 1)
             (gtags-make-complete-list)
             ))

;;gud-mode
(setq gdb-many-windows t)
(add-hook 'c-mode-common-hook
        '(lambda ()
            ;; 色々な設定
            (define-key c-mode-base-map "\C-c\C-c" 'comment-region)
            (define-key c-mode-base-map "\C-c\M-c" 'uncomment-region)
            (define-key c-mode-base-map "\C-cg"       'gdb)
            (define-key c-mode-base-map "\C-cc"       'make)
            (define-key c-mode-base-map "\C-ce"       'c-macro-expand)
            ;(define-key c-mode-base-map "\C-ct"        'toggle-source)
            ))
(add-hook 'gdb-mode-hook
        (lambda ()
            (if ecb-minor-mode
                (ecb-deactivate)
            )))

;;clipboard
(setq x-select-enable-clipboard t)

;;package
(require 'package)

; Add package-archives
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

; Initialize
(package-initialize)

;; melpa.el
;(require 'melpa)

(with-eval-after-load 'tex-jp
  (setq TeX-engine-alist '((pdfuptex "pdfupTeX"
                                     "ptex2pdf -u -e -ot \"-kanji=utf8 -no-guess-input-enc %S %(mode)\""
                                     "ptex2pdf -u -l -ot \"-kanji=utf8 -no-guess-input-enc %S %(mode)\""
                                     "euptex")))
  (setq japanese-TeX-engine-default 'pdfuptex)
  ;(setq japanese-TeX-engine-default 'luatex)
  ;(setq japanese-TeX-engine-default 'xetex)
  (setq TeX-view-program-list '(("SumatraPDF"
                                 "powershell -Command \"& {$r = Write-Output %o;$t = Write-Output %b;$o = [System.String]::Concat('\"\"\"',[System.IO.Path]::GetFileNameWithoutExtension($r),'.pdf','\"\"\"');$b = [System.String]::Concat('\"\"\"',[System.IO.Path]::GetFileNameWithoutExtension($t),'.tex','\"\"\"');Start-Process SumatraPDF -ArgumentList ('-reuse-instance',$o,'-forward-search',$b,%n)}\"")))
  (setq TeX-view-program-selection '((output-dvi "SumatraPDF")
                                     (output-pdf "SumatraPDF")))
  (setq japanese-LaTeX-default-style "bxjsarticle")
  ;(setq japanese-LaTeX-default-style "ltjsarticle")
  (dolist (command '("pTeX" "pLaTeX" "pBibTeX" "jTeX" "jLaTeX" "jBibTeX" "Mendex"))
    (delq (assoc command TeX-command-list) TeX-command-list)))
(setq preview-image-type 'dvipng)
(setq TeX-source-correlate-method 'synctex)
(setq TeX-source-correlate-start-server t)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook
          (function (lambda ()
                      (add-to-list 'TeX-command-list
                                   '("Latexmk"
                                     "latexmk %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-upLaTeX-pdfdvi"
                                     "latexmk -e \"$latex=q/uplatex %%O -kanji=utf8 -no-guess-input-enc %S %(mode) %%S/\" -e \"$bibtex=q/upbibtex %%O %%B/\" -e \"$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/\" -e \"$makeindex=q/upmendex %%O -o %%D %%S/\" -e \"$dvipdf=q/dvipdfmx %%O -o %%D %%S/\" -norc -gg -pdfdvi %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-upLaTeX-pdfdvi"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-upLaTeX-pdfps"
                                     "latexmk -e \"$latex=q/uplatex %%O -kanji=utf8 -no-guess-input-enc %S %(mode) %%S/\" -e \"$bibtex=q/upbibtex %%O %%B/\" -e \"$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/\" -e \"$makeindex=q/upmendex %%O -o %%D %%S/\" -e \"$dvips=q/dvips %%O -z -f %%S | convbkmk -u > %%D/\" -e \"$ps2pdf=q/ps2pdf.exe %%O %%S %%D/\" -norc -gg -pdfps %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-upLaTeX-pdfps"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-pdfLaTeX"
                                     "latexmk -e \"$pdflatex=q/pdflatex %%O %S %(mode) %%S/\" -e \"$bibtex=q/bibtex %%O %%B/\" -e \"$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/\" -e \"$makeindex=q/makeindex %%O -o %%D %%S/\" -norc -gg -pdf %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-pdfLaTeX"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-LuaLaTeX"
                                     "latexmk -e \"$pdflatex=q/lualatex %%O %S %(mode) %%S/\" -e \"$bibtex=q/upbibtex %%O %%B/\" -e \"$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/\" -e \"$makeindex=q/upmendex %%O -o %%D %%S/\" -norc -gg -pdf %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-LuaLaTeX"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-LuaJITLaTeX"
                                     "latexmk -e \"$pdflatex=q/luajitlatex %%O %S %(mode) %%S/\" -e \"$bibtex=q/upbibtex %%O %%B/\" -e \"$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/\" -e \"$makeindex=q/upmendex %%O -o %%D %%S/\" -norc -gg -pdf %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-LuaJITLaTeX"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-XeLaTeX"
                                     "latexmk -e \"$pdflatex=q/xelatex %%O %S %(mode) %%S/\" -e \"$bibtex=q/upbibtex %%O %%B/\" -e \"$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/\" -e \"$makeindex=q/upmendex %%O -o %%D %%S/\" -norc -gg -pdf %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-XeLaTeX"))
                      (add-to-list 'TeX-command-list
                                   '("SumatraPDF"
                                     "powershell -Command \"& {$r = Write-Output %o;$t = Write-Output %b;$o = [System.String]::Concat('\"\"\"',[System.IO.Path]::GetFileNameWithoutExtension($r),'.pdf','\"\"\"');$b = [System.String]::Concat('\"\"\"',[System.IO.Path]::GetFileNameWithoutExtension($t),'.tex','\"\"\"');Start-Process SumatraPDF -ArgumentList ('-reuse-instance',$o,'-forward-search',$b,%n)}\""
                                     TeX-run-discard-or-function t t :help "Forward search with SumatraPDF"))
                      (add-to-list 'TeX-command-list
                                   '("fwdsumatrapdf"
                                     "fwdsumatrapdf %s.pdf \"%b\" %n"
                                     TeX-run-discard-or-function t t :help "Forward search with SumatraPDF"))
                      (add-to-list 'TeX-command-list
                                   '("TeXworks"
                                     "synctex view -i \"%n:0:%b\" -o %s.pdf -x \"texworks --position=%%{page+1} %%{output}\""
                                     TeX-run-discard-or-function t t :help "Run TeXworks"))
                      (add-to-list 'TeX-command-list
                                   '("TeXstudio"
                                     "synctex view -i \"%n:0:%b\" -o %s.pdf -x \"texstudio --pdf-viewer-only --page %%{page+1} %%{output}\""
                                     TeX-run-discard-or-function t t :help "Run TeXstudio"))
                      (add-to-list 'TeX-command-list
                                   '("Firefox"
                                     "powershell -Command \"& {$r = Write-Output %o;$o = [System.String]::Concat('\"\"\"',[System.IO.Path]::GetFileNameWithoutExtension($r),'.pdf','\"\"\"');Start-Process firefox -ArgumentList ('-new-window',$o)}\""
                                     TeX-run-discard-or-function t t :help "Run Mozilla Firefox"))
                      (add-to-list 'TeX-command-list
                                   '("Chrome"
                                     "powershell -Command \"& {$r = Write-Output %s.pdf;$o = [System.String]::Concat('\"\"\"',[System.IO.Path]::GetFullPath($r),'\"\"\"');Start-Process chrome -ArgumentList ('--new-window',$o)}\""
                                     TeX-run-discard-or-function t t :help "Run Chrome PDF Viewer"))
                      (add-to-list 'TeX-command-list
                                   '("pdfopen"
                                     "tasklist /fi \"IMAGENAME eq AcroRd32.exe\" /nh | findstr \"AcroRd32.exe\" > nul && pdfopen --r15 --file %s.pdf && pdfclose --r15 --file %s.pdf & synctex view -i \"%n:0:%b\" -o %s.pdf -x \"pdfopen --r15 --file %%{output} --page %%{page+1}\""
                                     TeX-run-discard-or-function t t :help "Run Adobe Acrobat Reader DC")))))

;;
;; RefTeX with AUCTeX
;;
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;;
;; kinsoku.el
;;
(setq kinsoku-limit 10)

;;
;; auctex-latexmk
;;
;; (require 'auctex-latexmk)
;; (auctex-latexmk-setup)
;; (add-hook 'LaTeX-mode-hook (lambda ()
;; 			     (push
;; 			      '("latexmk" "latexmk -pdf %s" TeX-run-TeX nil turn-on-reftex      :help "Run latexmk on file")
;; 			      TeX-command-list)))
;; (add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))

;;org-tree-slide
(require 'org-tree-slide)
(setq org-tree-slide-heading-emphasis t)
(define-key global-map (kbd "<f5>") 'org-tree-slide-mode)

;;latex-math-preview
(autoload 'latex-math-preview-expression "latex-math-preview" nil t)
(autoload 'latex-math-preview-insert-symbol "latex-math-preview" nil t)
(autoload 'latex-math-preview-save-image-file "latex-math-preview" nil t)
(autoload 'latex-math-preview-beamer-frame "latex-math-preview" nil t)

;; js2-mode

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))


;; (add-hook 'js2-mode-hook
;;     (lambda ()
;;         (tern-mode t)))

(eval-after-load 'tern
    '(progn
        (require 'tern-auto-complete)
        (tern-ac-setup)))

;; (add-hook 'js2-mode-hook
;;     (lambda ()
;;       (slime-js-minor-mode 1)))

;; (require 'slime)
;; (setq inferior-lisp-program "/usr/local/bin/clisp")
;; (slime-setup '(slime-repl slime-fancy slime-banner slime-js))

 ;; (setq inferior-lisp-program "/usr/local/bin/sbcl")
 ;; (setq slime-contribs '(slime-fancy))


;;octave-mode
 ;; (autoload 'octave-mode "octave-mode" nil t)
 ;; (setq auto-mode-alist
 ;;       (cons '("\\.m$" . octave-mode) auto-mode-alist))

;; (add-hook 'octave-mode-hook
;;           (lambda ()
;;             (abbrev-mode 1)
;;             (auto-fill-mode 1)
;;             (if (eq window-system 'x)
;;                 (font-lock-mode 1))))

;;
;;OrgMode
;;

;; Org Mode LaTeX Export
(require 'ox-latex)
(require 'ox-bibtex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))

(setq org-latex-subtitle-separate t)

(setq org-latex-with-hyperref nil)

;; pdf process = latexmk
(setq org-latex-pdf-process '("latexmk %f"))

;; default class = jsarticle
(setq org-latex-default-class "jsarticle")

;; org-latex-classes
(add-to-list 'org-latex-classes
             '("jsarticle"
               "\\documentclass[11pt,a4paper,uplatex]{jsarticle}
                [NO-DEFAULT-PACKAGES] [PACKAGES] [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
               ))

;; wordclass
(add-to-list 'org-latex-classes
             '("word"
               "\\documentclass{word}
	       [NO-DEFAULT-PACKAGES] [PACKAGES] [EXTRA]"
	       ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
               ))

;; Beamer
(add-to-list 'org-latex-classes
             '("beamer"
               "\\documentclass[dvipdfmx,presentation]{beamer}
               [NO-DEFAULT-PACKAGES] [PACKAGES] [EXTRA]"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

;; org-export-latex-no-toc
(defun org-export-latex-no-toc (depth)
    (when depth
      (format "%% Org-mode is exporting headings to %s levels.\n"
              depth)))

;; Disabling key bindings "\C-,"
(eval-after-load "org"
  '(progn
     (define-key org-mode-map (kbd "C-,") nil)
     ))

;; reftex with org mode
(add-hook 'org-mode-hook 'turn-on-reftex)
(defun org-mode-reftex-setup ()
   (load-library "reftex")
   (and (buffer-file-name)
        (file-exists-p (buffer-file-name))
        (reftex-parse-all))
   (define-key org-mode-map (kbd "C-c [") 'reftex-citation))

;;Oniisama!
(require 'oniisama)

;;Emoji
(add-to-list 'load-path "~/.emacs.d/config/emacs-emoji-cheat-sheet")
(require 'emoji-cheat-sheet)
(put 'set-goal-column 'disabled nil)

;;Markdown
(setq markdown-command "multimarkdown")

;;Python jedi
;; (jedi:setup)
;; (define-key jedi-mode-map (kbd "<C-tab>") nil) ;;C-tabはウィンドウの移動に用いる
;; (setq jedi:complete-on-dot t)
;; (setq ac-sources
;;       (delete 'ac-source-words-in-same-mode-buffers ac-sources)) ;;jediの補完候補だけでいい
;; (add-to-list 'ac-sources 'ac-source-filename)
;; (add-to-list 'ac-sources 'ac-source-jedi-direct)
;; (define-key python-mode-map "\C-cd" 'jedi:goto-definition)


;;Haskell mode
(autoload 'haskell-mode "haskell-mode" nil t)
(autoload 'haskell-cabal "haskell-cabal" nil t)

(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'auto-mode-alist '("\\.cabal\\'" . haskell-cabal-mode))
