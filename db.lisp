(in-package #:scorer)

(defvar *db* nil)

(defvar *current-round* nil)

(defun hash->list (hash)
  (let (list)
    (flet ((save-slot (key value)
	     (push (cons key (if (typep value 'hash-table)
				 (hash->list value)
				 value))
		   list)))
      (maphash #'save-slot hash)
      list)))

(defun person-in-db (person)
  (loop
     :for x :in *db*
     :when (equal x person) :return t))

(defun person-in-cround (person)
  (let ((*db* *current-round*))
    ;; Dynamic scope for the win
    (person-in-db person)))

(defun get-name-from-db (itm)
  (loop
     for x in *current-round*
     do (if (equalp  (cdr (assoc :name x)) itm)
	    (return x))))

(defun db-entry->person (name)
  (let ((alist (get-name-from-db name)))
    (let ((name (cdr (assoc :name alist)))
	  (forms (cdr (assoc :forms alist)))
	  (score (cdr (assoc :score alist)))
	  (final-score (cdr (assoc :final-score alist)))
	  (total (cdr (assoc :total alist)))))))

(defun alistp (list)
  (and (listp list)
       (every #'consp list)))

