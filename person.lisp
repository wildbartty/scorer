(in-package :scorer)

(defun ask-input (question)
  (format t "~a~%" question)
  (read-line))

(defun read-config (file)
  (let ((string (read-file-into-string file)))
    (cl-yaml:parse string)))

(defvar *config-table* (read-config "test.yaml"))
(defconstant +score-table+ (gethash "scores" *config-table*))

(defclass person ()
  ((name :accessor name)
   (table :accessor p-table)
   (score-table :accessor score-table)
   (score :accessor score)
  )) 

(defmethod initialize-instance :after ((person person) &key)
  (let ((name (ask-input "whats the name"))
	(table *config-table*))
    (setf (name person) name)
    (setf (p-table person) table)
    (setf (score-table person) +score-table+)))

(defgeneric get-score-in (var))

(defmethod get-score-in ((person person))
  )

(defmethod parse-score ((person person) (score t))
  (gethash score (score-table person)))
