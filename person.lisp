(in-package :scorer)

(defun t->string (x)
  "converts any printable t to a string"
  (format nil "~a" x))

(defun split-by-spaces (str)
  (split-sequence #\space str))

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
  (let ((string (read-file-into-string file)))
    (cl-json:decode-json-from-string string)))
;; explicit package used because parse is too generic
;; meaning

(defun str-arround (str thing1 thing2)
  "returns a string wraped with "
  (concatenate 'string thing1 str thing2))

(defun make-bar (num)
  "makes a string that is num long with all elements equal to +hbar+"
  (make-string num :initial-element (aref +hbar+ 0)))

(defparameter *current-config* (read-config "test.json"))

(defun make-person (&key (name "") (sport "") (score nil) (date (today)) (forms nil))
  (let ((ret (list :name   name
		   :date   date
		   :score  score
		   :sport  sport
		   :forms  forms)))
    (unless (person-in-cround ret) (push ret *current-round*))
    (sort *current-round* #'string-lessp :key (lambda (x) (getf x :name)))
    ret))

