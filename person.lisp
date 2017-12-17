(in-package :scorer)

(defun split-by-spaces (str)
  (split-sequence #\space str))

(defclass person (score)
  ((name :accessor name :initarg :name)
   (score :reader score :initform (make-instance 'score) :initarg :score)
   (forms :accessor forms :initform nil :initarg :forms)
   (time  :accessor person-time :initform nil
	  :initarg :time)
   (ammount :initform 0 :accessor p-ammount :allocation :class)
   (from-db :initarg :from-db :initform nil :reader from-db))) 

(defmethod initialize-instance :after ((person person) &key)
  (unless (from-db person)
      (let ((name (ask-input "whats the name"))
	    (forms (ask-input "what are the forms")))
	(incf (p-ammount person))
	(setf (forms person) (split-by-spaces forms))
	(setf (name person) name))
      (push (score->table person) *current-round*)))

(defmethod score-round :after ((person person))
  ;(push (score->table person) *current-round*)
  )
