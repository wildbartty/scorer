(in-package :scorer)

(defconstant +hbar+    (code-char #x2500))
(defconstant +vbar+    (code-char #x2502))
(defconstant +ul-c+    (code-char #x250c))
(defconstant +ur-c+    (code-char #x2510))
(defconstant +dr-c+    (code-char #x2514))
(defconstant +dl-c+    (code-char #x2518))
(defconstant +left-t+  (code-char #x251c))
(defconstant +right-t+ (code-char #x2524))
(defconstant +up-t+    (code-char #x252c))
(defconstant +down-t+  (code-char #x2534))
(defconstant +mid-t+   (code-char #x253c))

(defun ask-input (question)
  (format t "~a~%" question)
  (read-line))

(defun read-config (file)
  (let ((string (read-file-into-string file)))
    (cl-yaml:parse string)))

(defun t->string (x)
  (format nil "~a" x))

(defvar *current-config* (read-config "test.yaml"))
(defvar *score-table* (gethash "scores" *current-config*))

(defclass score ()
  ((table :accessor p-table)
   (score-table :accessor score-table)
   (score :accessor score)
   (rounds :reader rounds)
   (final-score :accessor final-score)
   (running-score-val :accessor running-score-val)
   (ret-table :accessor ret-table)
   (ret-table-str :accessor str-table)))

(defclass person ()
  ((name :accessor name)
   (score :reader score :initform (make-instance 'score))
   )) 

(defmethod initialize-instance :after ((person person) &key)
  (let ((name (ask-input "whats the name")))
    (setf (name person) name))))

(defmethod initialize-instance :after ((score score) &key)
  (let ((table *current-config*)
	(score-table *score-table*))
    (setf (p-table score) table
	  (score-table score) score-table)))
(defgeneric get-score-in (var))

(defmethod get-score-in ((score score))
  (push (ask-input "score?") (score score))
  )

(defmethod parse-score (score val)
  (gethash val (score-table score)))

(defmethod get-score-vals ((score score))
  (mapcar #'(lambda (x) (parse-score score x)) (score score)))

(defmethod score-round ((score score))
  (setf (score score) nil)
  (setf (score score)
	(loop
	   for x from 1 upto (rounds score)
	   collect (ask-input "score?")
	     )))

(defmethod running-score ((score score))
  (setf (running-score-val score)
	(let ((list (final-score score)))
	  (let ((len (length list)))
	    (loop for x from 1 upto len
	       collect (reduce #'+ (subseq list 0 x)))))))

(defmethod score-round :after ((score score))
  (setf (final-score score) (get-score-vals score)))

(defmethod collect-to-table ((score score))
  (setf (ret-table score) 
	(let ((score (score score))
	      (final-score (final-score score))
	      (running-score (running-score-val score)))
	  (loop
	     for x in score
	     for y in final-score
	     for z in running-score
	     collect (list x y z)))))

(defmethod collect-to-table :after ((score score))
  "Converts all of the contents in ret-table to a string"
  (setf (str-table score)
	;;(mapcar #'(lambda (x) (mapcar #'(lambda (y) (t->string y)) x)) *)
	;;why did this not throw an error?
	(mapcar #'(lambda (x) (mapcar #'(lambda (y) (t->string y)) x)) (ret-table score))))
(defun append-to-all (lst char) 
  (loop for x in lst 
     collect (loop for y in x
		collect (coerce (append (coerce y 'list) (list char)) 'string))))
(defun add-vbar (x) 
  (append-to-all x +vbar+))

(defmethod reduce-strings ((score score))
  (let* ((plst (str-table score))
	 (lst (add-vbar plst)))
    (loop for x in lst
	 collect (reduce #'(lambda (a b) (concatenate 'string a b)) x))))
