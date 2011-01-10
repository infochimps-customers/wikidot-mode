;;; wikidot-mode.el --- Major mode for editing documents from Wikidot (http://wikidot.com)

;; Copyright (C) 2006 Free Software Foundation, Inc.

;; Author: Dhruv Bansal <dhruv@infochimps.com>

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:
;;
;; This is a mode for editing documents from Wikidot
;; (http://wikidot.com).  It's based on code from SampleMode
;; (http://www.emacswiki.org/emacs/SampleMode) and textile-mode.el
;; (http://www.emacswiki.org/emacs/TextileMode).

(defvar wikidot-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-c>" 'wikidot-increase-bullet-indent)
    (define-key map "\C-c<" 'wikidot-decrease-bullet-indent)
    map)
  "Keymap for `wikidot-mode'.")

(defun wikidot-increase-bullet-indent (count)
  "Increase the indent level of the current line or region (if defined) by a single space.  If given a prefix argument, increase by that many spaces instead."
  (interactive "p")
  (save-excursion
    (let* ((start (if (and transient-mark-mode mark-active)
		     (region-beginning)
		   (line-beginning-position)))
	  (end (if (and transient-mark-mode mark-active)
		     (region-end)
		   (line-end-position)))
	  (num-spaces (if (and count (> count 0))
			  count
			1))
	  )
      (goto-char start)
      (while (< (point) end)
	(beginning-of-line)
	(insert-char 32 num-spaces)
	(forward-line)))))

(defun wikidot-decrease-bullet-indent (count)
  "Decrease the indent level of the current line or region (if defined) by a single space.  If given a prefix argument, decrease by that many spaces instead."
  (interactive "p")
  (save-excursion
    (let* ((start (if (and transient-mark-mode mark-active)
		     (region-beginning)
		   (line-beginning-position)))
	  (end (if (and transient-mark-mode mark-active)
		     (region-end)
		   (line-end-position)))
	  (num-spaces (if (and count (> count 0))
			  count
			1))
	  )
      (goto-char start)
      (while (< (point) end)
	(beginning-of-line)
	(let ((num-spaces-deleted 0))
	  (while (and
		  (looking-at "^ ")
		  (< num-spaces-deleted num-spaces))
	    (delete-char 1)
	    (setq num-spaces-deleted (+ 1 num-spaces-deleted))))
	(forward-line)))))

;; (defvar wikidot-mode-syntax-table
;;   (let ((st (make-syntax-table)))
;;     (modify-syntax-entry ?# "<" st)
;;     (modify-syntax-entry ?\n ">" st)
;;     st)
;;   "Syntax table for `wikidot-mode'.")


(defvar wikidot-mode-font-lock-keywords
  '(
    ("\\[!--.*--\\]" 		  	  0 'font-lock-comment-face)
    ("^\\+\\*? +.*$" 		  	  0 'wikidot-h1-face)
    ("^\\+\\+\\*? +.*$" 		  0 'wikidot-h2-face)
    ("^\\+\\+\\+\\*? +.*$" 	  	  0 'wikidot-h3-face)
    ("^\\+\\+\\+\\+\\*? +.*$" 	  	  0 'wikidot-h4-face)
    ("^\\+\\+\\+\\+\\+\\*? +.*$" 	  0 'wikidot-h5-face)
    ("^\\+\\+\\+\\+\\+\\+\\*? +.*$" 	  0 'wikidot-h6-face)

    ("//.*?//" 				  0 'wikidot-italics-face)
    ("\\*\\*.*?\\*\\*" 			  0 'wikidot-bold-face)
    ("__.*?__" 				  0 'wikidot-underline-face)
    ("--.*?--" 				  0 'wikidot-strikethrough-face)
    ("{{.*?}}"   			  0 'wikidot-code-face)
    ("\\^\\^.*?\\^\\^" 			  0 'wikidot-superscript-face)
    (",,.*?,," 				  0 'wikidot-subscript-face)

    ("\\[\\[\\[.*?\\]\\]\\]"		  0 'wikidot-link-face)
    ("\\[.*?\\]"         		  0 'wikidot-link-face)

    ("^ *# +"                             0 'wikidot-ol-bullet-face)
    ("^ *\\* +"				  0 'wikidot-ul-bullet-face)

    ("\\[\\[\\?.*?\\]\\]"		  0 'wikidot-link-face) ; FIXME for [[note]] constructs

    
    )
  "Keyword highlighting specification for `wikidot-mode'.")

;; (defvar wikidot-imenu-generic-expression
;;   ...)

;; (defvar wikidot-outline-regexp
;;   ...)

;;;###autoload
(define-derived-mode wikidot-mode fundamental-mode "Wikidot"
  "Major mode to edit Wikidot markup."
  (set (make-local-variable 'font-lock-defaults)
       '(wikidot-mode-font-lock-keywords))
  (set (make-local-variable 'comment-start) "\[!--")
  (set (make-local-variable 'comment-end) "--\]")
  ;; (set (make-local-variable 'indent-line-function) 'wikidot-indent-line)
  ;; (set (make-local-variable 'imenu-generic-expression)
  ;;      wikidot-imenu-generic-expression)
  ;; (set (make-local-variable 'outline-regexp) wikidot-outline-regexp)
  )


;;; Indentation

;; (defun wikidot-indent-line ()
;;   "Indent current line of Wikidot code."
;;   (interactive)
;;   (let ((savep (> (current-column) (current-indentation)))
;; 	(indent (condition-case nil (max (wikidot-calculate-indentation) 0)
;; 		  (error 0))))
;;     (if savep
;; 	(save-excursion (indent-line-to indent))
;;       (indent-line-to indent))))

;; (defun wikidot-calculate-indentation ()
;;   "Return the column to which the current line should be indented."
;;   ...)


(defgroup wikidot-faces nil
  "Faces used by wikidot-mode for syntax highlighting"
  :group 'faces)

(defface wikidot-h1-face
  '((t (:height 2.0 :weight bold)))
  "Face used to highlight h1 headers."
  :group 'wikidot-faces)

(defface wikidot-h2-face
  '((t (:height 1.75 :weight bold)))
  "Face used to highlight h2 headers."
  :group 'wikidot-faces)

(defface wikidot-h3-face
  '((t (:height 1.6 :weight bold)))
  "Face used to highlight h3 headers."
  :group 'wikidot-faces)

(defface wikidot-h4-face
  '((t (:height 1.35 :weight bold)))
  "Face used to highlight h4 headers."
  :group 'wikidot-faces)

(defface wikidot-h5-face
  '((t (:height 1.2 :weight bold)))
  "Face used to highlight h5 headers."
  :group 'wikidot-faces)

(defface wikidot-h6-face
  '((t (:height 1.0 :weight bold)))
  "Face used to highlight h6 headers."
  :group 'wikidot-faces)

(defface wikidot-blockquote-face
  '((t (:foreground "ivory4")))
  "Face used to highlight bq blocks."
  :group 'wikidot-faces)

(defface wikidot-footnote-face
  '((t (:foreground "orange red")))
  "Face used to highlight footnote blocks."
  :group 'wikidot-faces)

(defface wikidot-footnotemark-face
  '((t (:foreground "orange red")))
  "Face used to highlight footnote marks."
  :group 'wikidot-faces)

(defface wikidot-style-face
  '((t (:foreground "sandy brown")))
  "Face used to highlight style parameters."
  :group 'wikidot-faces)

(defface wikidot-class-face
  '((t (:foreground "yellow green")))
  "Face used to highlight class and id parameters."
  :group 'wikidot-faces)

(defface wikidot-lang-face
  '((t (:foreground "sky blue")))
  "Face used to highlight lang parameters."
  :group 'wikidot-faces)

(defface wikidot-italics-face
  '((t (:slant italic)))
  "Face used to highlight emphasized words."
  :group 'wikidot-faces)

(defface wikidot-bold-face
  '((t (:weight bold)))
  "Face used to highlight strong words."
  :group 'wikidot-faces)

(defface wikidot-code-face
  '((t (:foreground "ivory3")))
  "Face used to highlight inline code."
  :group 'wikidot-faces)

(defface wikidot-citation-face
  '((t (:slant italic)))
  "Face used to highlight citations."
  :group 'wikidot-faces)

(defface wikidot-strikethrough-face
  '((t (:strike-through t)))
  "Face used to highlight deleted words."
  :group 'wikidot-faces)

(defface wikidot-underline-face
  '((t (:underline t)))
  "Face used to highlight inserted words."
  :group 'wikidot-faces)

(defface wikidot-superscript-face
  '((t (:height 1.1)))
  "Face used to highlight superscript words."
  :group 'wikidot-faces)

(defface wikidot-subscript-face
  '((t (:height 0.8)))
  "Face used to highlight subscript words."
  :group 'wikidot-faces)

(defface wikidot-span-face
  '((t (:foreground "pink")))
  "Face used to highlight span words."
  :group 'wikidot-faces)

(defface wikidot-alignments-face
  '((t (:foreground "cyan")))
  "Face used to highlight alignments."
  :group 'wikidot-faces)

(defface wikidot-ol-bullet-face
  '((t (:foreground "red")))
  "Face used to highlight ordered lists bullets."
  :group 'wikidot-faces)

(defface wikidot-ul-bullet-face
  '((t (:foreground "blue")))
  "Face used to highlight unordered list bullets."
  :group 'wikidot-faces)

(defface wikidot-pre-face
  '((t (:foreground "green")))
  "Face used to highlight <pre> blocks."
  :group 'wikidot-faces)

(defface wikidot-code-face
  '((t (:foreground "yellow")))
  "Face used to highlight <code> blocks."
  :group 'wikidot-faces)

(defface wikidot-table-face
  '((t (:foreground "red")))
  "Face used to highlight tables."
  :group 'wikidot-faces)

(defface wikidot-link-face
  '((t (:foreground "blue")))
  "Face used to highlight links."
  :group 'wikidot-faces)

(defface wikidot-image-face
  '((t (:foreground "pink")))
  "Face used to highlight image links."
  :group 'wikidot-faces)

(defface wikidot-acronym-face
  '((t (:foreground "cyan")))
  "Face used to highlight acronyms links."
  :group 'wikidot-faces)

(provide 'wikidot-mode)
