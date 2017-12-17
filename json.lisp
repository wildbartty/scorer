(in-package :scorer)

(defun str-tree->list (str)
  (let ((lst str))
    lst))

(defun json-bool->lisp (str)
  (cond
    ((equalp "true" str) t)
    ((equalp "false" str) nil)))
