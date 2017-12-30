(in-package :scorer)

(defun alistp (list)
  (and (proper-list-p list)
       (every #'consp list)))

