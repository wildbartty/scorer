(in-package :scorer)

(defun t->string (x)
  (format nil "~a" x))

(defparameter +hbar+    (t->string (code-char #x2500)))
(defparameter +vbar+    (t->string (code-char #x2502)))
(defparameter +ul-c+    (t->string (code-char #x250c)))
(defparameter +ur-c+    (t->string (code-char #x2510)))
(defparameter +dr-c+    (t->string (code-char #x2514)))
(defparameter +dl-c+    (t->string (code-char #x2518)))
(defparameter +left-t+  (t->string (code-char #x251c)))
(defparameter +right-t+ (t->string (code-char #x2524)))
(defparameter +up-t+    (t->string (code-char #x252c)))
(defparameter +down-t+  (t->string (code-char #x2534)))
(defparameter +mid-t+   (t->string (code-char #x253c)))

(defun get-hash (object table)
  (gethash object table))

(defun ask-input (question)
  (format t "~a~%" question)
  (read-line))

(defun read-config (file)
  (let ((string (read-file-into-string file)))
    (cl-yaml:parse string)))

(defun str-arround (str thing1 thing2)
  (concatenate 'string thing1 str thing2))

(defun make-bar (num)
  (make-string num :initial-element (aref +hbar+ 0)))

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

(defmethod initialize-instance :after ((score score) &key)
  (let ((table *current-config*)
	(score-table *score-table*))
    (setf (p-table score) table
	  (slot-value score 'rounds) (gethash "rounds" table)
	  (score-table score) score-table)))
(defgeneric get-score-in (var))

(defmethod get-score-in ((score score))
  (push (ask-input "score?") (score score)))

(defmethod parse-score (score val)
  (gethash val (score-table score)))

(defmethod get-score-vals ((score score))
  (mapcar #'(lambda (x) (parse-score score x)) (score score)))

(defmethod test-score ((score score))
  (let* ((place (get-score-vals score))
	 (tlist (member nil place)))
    (if tlist
	(values place (- (length place) (length tlist)))
	(values place -1)
	)))


(defmethod running-score ((score score))
  (setf (running-score-val score)
	(let ((list (final-score score)))
	  (let ((len (length list)))
	    (loop for x from 1 upto len
	       collect (reduce #'+ (subseq list 0 x)))))))

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

(defmethod score-round ((score score))
  (setf (score score) nil)
  (setf (score score)
	(loop
	   for x from 1 upto (rounds score)
	   collect (ask-input "score?")
	     )))

(defmethod score-round :after ((score score))
  (setf (final-score score) (get-score-vals score)
	(running-score-val score) (running-score score))
  (collect-to-table score))

(defun append-to-all (lst char) 
  (loop for x in lst 
     collect (loop for y in x
		collect (coerce (append (coerce y 'list) (list char)) 'string))))

(defun add-vbar (x) 
  (append-to-all x +vbar+))

(defgeneric to-mid-bar (str)
  (:documentation " on a string it returns
a string with length n+1 on a score object it returns the
str-table but with the string case applied to each sublist"))

(defmethod to-mid-bar ((str string))
  (concatenate 'string (make-bar (length str)) +mid-t+))

(defmethod to-mid-bar ((score score))
  (let ((strs 
	 (concatenate 'string +left-t+ 
		      (loop for y in
			   (loop for x in (str-table score)
			      collect (mapcar #'to-mid-bar x))
			 collect (let ((lst (reduce #'(lambda (a b) (concatenate 'string a b)) y)))
				   (subseq lst 0 (1- (length lst))))) +right-t+)))
    strs
;    (mapcar #'(lambda (x) (str-arround )))
    ))


(defmethod reduce-strings ((score score))
  (let* ((plst (str-table score))
	 (lst (add-vbar plst)))
    (loop for x in lst
       collect (reduce #'(lambda (a b) (concatenate 'string a b)) x))))

(defclass person (score)
  ((name :accessor name)
   (score :reader score :initform (make-instance 'score))
   (ammount :initform 0 :accessor p-ammount :allocation :class)
   )) 

(defmethod initialize-instance :after ((person person) &key)
  (let ((name (ask-input "whats the name")))
    (incf (p-ammount person))
    (setf (name person) name)))

