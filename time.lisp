(in-package :scorer)

(defclass s-time ()
  ((ms   :initarg :ms   :initform 0 :accessor ms  )
   (sec :initarg :sec :initform 0 :accessor sec)
   (mins :initarg :mins :initform 0 :accessor mins)
   (hour :initarg :hour :initform 0 :accessor hour)))


(defmethod time->int ((time s-time))
  (let ((ret (ash (hour time) 19)))
    (setf (ldb (byte 7 0) ret) (ms time)
	  (ldb (byte 6 7) ret) (sec time)
	  (ldb (byte 6 13) ret) (mins time))
    ret))

(defmethod int->time ((num integer))
  (labels ((remove-digits (num)
	     "Hello"
	     (ash  (- num (ldb (byte 19 0) num)) -19)))
    (let ((hour (remove-digits num))
	  (mins (ldb (byte 6 13) num))
	  (sec (ldb (byte 6 7) num))
	  (ms (ldb (byte 7 0) num)))
      (make-instance 's-time :hour hour :mins mins :sec sec :ms ms))))

(defmethod gt-time ((time s-time) (time2 s-time))
  (let ((t1 (time->int time)) (t2 (time->int time2)))
    (> t1 t2)))

(defmethod cl:print-object ((time s-time) stream)
  (print-unreadable-object (time stream :type t)
    (with-slots (ms sec mins hour) time
      (format stream "ms: ~s sec: ~s mins: ~s hour: ~s"
	      ms sec mins hour))))
