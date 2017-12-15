(in-package :scorer)

(defun t->string (x)
  "converts any printable t to a string"
  (format nil "~a" x))

;;; TODO: find a way to make these constants without
;;; sbcl complaining when i recompile 
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

;;(defparameter +hbar+    "-")
;;(defparameter +vbar+    (t->string (code-char #x2502)))
;;(defparameter +ul-c+    "+")
;;(defparameter +ur-c+    "+")
;;(defparameter +dr-c+    "+")
;;(defparameter +dl-c+    "+")
;;(defparameter +left-t+  "+")
;;(defparameter +right-t+ "+")
;;(defparameter +up-t+    "+")
;;(defparameter +down-t+  "+")
;;(defparameter +mid-t+   (t->string (code-char #x253c)))

(defun get-hash (object table)
  "because i cant spell"
  (gethash object table))

(defun ask-input (question)
  "a helper function to get input
   easily"
  (format t "~a~%" question)
  (read-line))

(defun read-config (file)
  "reads a config file"
  (with-input-from-file (stream file)
			(decode-json)))


(defun str-arround (str thing1 thing2)
  "returns a string wraped with "
  (concatenate 'string thing1 str thing2))

(defun make-bar (num)
  "makes a string that is num long with all elements equal to +hbar+"
  (make-string num :initial-element (aref +hbar+ 0)))

(defvar *current-config* (read-config "test.json"))
(defvar *score-table* (gethash "scores" *current-config*))

(defclass score ()
  ;;the class that stores the score
  ((table             :accessor p-table)
   (score-table       :initform nil :accessor score-table)
   (score             :initform nil :accessor score)
   (rounds            :initform nil :reader   rounds)
   (parsed-score      :initform nil :accessor parsed-score)
   (final-score       :initform nil :accessor final-score)
   (running-score-val :initform nil :accessor running-score-val)
   (ret-table         :initform nil :accessor ret-table)
   (ret-table-str     :initform nil :accessor str-table)))

(defmethod initialize-instance :after ((score score) &key)
  "sets the class slots base on current config"
  (let ((table *current-config*)
	(score-table *score-table*))
    (setf (p-table score) table
	  (slot-value score 'rounds) (gethash "rounds" table)
	  (score-table score) score-table)))
(defgeneric get-score-in (var))

(defmethod get-score-in ((score score))
  "simple helper function"
  (push (ask-input "score?") (score score)))

(defmethod parse-score ((score  score) val)
  "returns the value of val in score"
  (gethash val (score-table score)))

(defmethod get-score-vals ((score score))
  "returns the parsed values of score"
  (mapcar #'(lambda (x) (parse-score score x)) (score score)))

(defmethod test-score ((score score))
  "tests if there are undefined elements in score"
  (let* ((place (get-score-vals score))
	 (tlist (member nil place)))
    (if tlist
	(- (length place) (length tlist))
      nil)))

(defgeneric set-score-at (score place value))

(defmethod set-score-at ((score score) (place fixnum) value)
  (setf (nth place (score score)) value))

;;ignore the cyclic dependency here
(defmethod running-score ((score score))
  "sets (running-score score) to be the accumulation of the past scores"
  (loop
   for x from 0 upto (length (parsed-score score))
   for y in (parsed-score score)
   when (not y) do (set-score-at score x
				 (let* ((fun (lambda () (ask-input (format
						    nil
						    "bad number at ~a~%whats the proper score?"
						    (1+ x)))))
					(ret (funcall fun)))
				   (loop until (parse-score score ret)
				      do (setq ret (funcall fun))
					return ret)))
   finally (setf (parsed-score score) (get-score-vals score)))
  (setf (running-score-val score)
	(let* ((list (parsed-score score))
	       (len (length list)))
	  (loop for x from 1 upto len
		collect (reduce #'+ (subseq list 0 x))))))

(defmethod collect-to-table ((score score))
  (setf (ret-table score) 
	(let ((score (score score))
	      (parsed-score (parsed-score score))
	      (running-score (running-score-val score)))
	  (loop
	   for x in score
	   for y in parsed-score
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
  (setf (parsed-score score) (get-score-vals score)
	(running-score-val score) (running-score score)
	(final-score score) (apply #'+ (parsed-score score)))
  (collect-to-table score)
  )

(defun append-to-all (lst char) 
  (loop for x in lst 
	collect (loop for y in x
		      collect (concatenate 'string y char))))

(defmethod collect-to-table ((score score))
  (setf (ret-table score) 
	(let ((score (score score))
	      (parsed-score (parsed-score score))
	      (running-score (running-score-val score)))
	  (loop
	   for x in score
	   for y in parsed-score
	   for z in running-score
	   collect (list x y z)))))

(defmethod collect-to-table :after ((score score))
  "Converts all of the contents in ret-table to a string"
  (setf (str-table score)
	;;(mapcar #'(lambda (x) (mapcar #'(lambda (y) (t->string y)) x)) *)
	;;why did this not throw an error?
	(mapcar #'(lambda (x) (mapcar #'(lambda (y) (t->string y)) x)) (ret-table score))))

(defmethod get-col-lengths ((score score ))
  "gets the width of columns when converting to a table"
  ;; we dont need to check the type in the funcs as it is done by
  ;; the defmethod
  (labels ((col2-length (score)
			(max (length "score")
			     (loop for x being each hash-key in (score-table score)
				   maximize (length (t->string x)))))
	   (col3-length (score) 
			(max (length "val")
			     (loop for x being each hash-value in (score-table score)
				   maximize (length (t->string x)))))
	   (col4-length (score)
			(max (length "acc")
			     (loop for x in (mapcar #'t->string (running-score-val score))
				   maximize (length x)))))
    (list (col2-length score)
	  (col3-length score)
	  (col4-length score)
	  )))

(defmethod col1-length ((score score))
  ;; out of method as it makes more sense
  ;; and is used in the table not in the
  ;; making of the itermediate strings
  (max (length "no")
       (length (t->string (rounds score)))))

(defmethod rightpad ((num fixnum) (str string))
  (labels ((spaces (num)
		   (when (> num 0)
		     (make-string num :initial-element #\space))))
    (concatenate 'string  (spaces (- num (length str))) str)))

(defun concat-str-lst (lst)
  (coerce (apply #'append  (mapcar #'(lambda (x) (coerce x 'list)) lst)) 'string))
  

(defgeneric to-mid-bar (str)
  (:documentation "on a string it returns
a string with length n+1 on a score object it returns the
str-table but with the string case applied to each sublist"))

(defmethod to-mid-bar ((str string))
  (concatenate 'string (make-bar (length str)) +mid-t+))

;; (defmethod to-mid-bar (string)
;;   (concatenate 'string +left-t+ 
;; 	       (loop for x in string
;; 		     collect (mapcar #'to-mid-bar x))
;; 	       +right-t+))

(defmethod to-mid-bar ((score score))
  (let ((lst 
	 (mapcar #'concat-str-lst  (loop for x in (str-table score)
				      collect (mapcar #'to-mid-bar x)))))
    (let ((id-string (car  (sort lst (lambda (x y) (> (length x) (length y)))))))
      (let ((ret-list (make-list (length lst) :initial-element 
				 (concatenate 'string +left-t+
					      (subseq id-string 0 (1- (length id-string)))
					      +right-t+))))
	(values  ret-list lst (length lst))))))

(defmethod add-vbar ((score score)) 
  (let ((lst (str-table score))
	(cols (get-col-lengths score)))
      (loop for x in lst 
	    collect (loop for y in x
			  for num upto (length x)
			  collect (concatenate 'string (rightpad (nth num cols) y) +vbar+)))))


(defmethod get-filled-columns ((score score))
  (let* ((lst (add-vbar score))
	 (ret0 
	  (loop for x in lst
		collect (reduce #'(lambda (a b) (concatenate 'string a b)) x))))
    (append
     (cons "|no|score|val|acc|" nil)
     (loop for x in ret0
	   for y from 0 upto (length ret0)
	   collect (let ((no (rightpad (col1-length score)
				       (t->string (1+ y)))))
		     (concatenate 'string +vbar+ no +vbar+ x)))
     )))

(defun split-by-spaces (str)
  (split-sequence #\space str))
