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

(defun split-by-spaces (str)
  (split-sequence #\space str))
