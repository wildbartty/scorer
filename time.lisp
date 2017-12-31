(in-package :scorer)

(defun current-date ()
    (multiple-value-bind (sec min hr day mnt year) (get-decoded-time)
      (list :sec    sec
	    :min    min
	    :hour    hr
	    :day    day
	    :month  mnt
	    :year  year)))

(defun today ()
  (let ((lst (current-date)))
    (list :day (getf lst :day)
	  :month (getf lst :month)
	  :year (getf lst :year))))
