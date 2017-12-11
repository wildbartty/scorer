(in-package #:scorer)

(defvar *db* nil)

(defvar *current-round* nil)

(defun make-base-table ()
  (let ((tmp (make-instance 'score))) 
    (list `(:meta .
		  ,(score->table tmp)
	    ))))

(defun hash->list (hash)
  (let (list)
    (flet ((save-slot (key value)
	     (push (cons key (if (typep value 'hash-table)
				 (hash->list value)
				 value))
		   list)))
      (maphash #'save-slot hash)
      list)))

(defun make-score-table (&key (mode "") (sport "") (rounds -1) scores)
  "Returns a plist "
  (list `(:score-table . nil)
	`(:mode   . ,mode)
	`(:sport  . ,sport)
	`(:rounds . ,rounds)
	`(:scores . ,scores)))

(defmethod score->table ((score score))
  (let ((hash (p-table score)))
    (let ((mode (make-keyword (gethash "mode" hash)))
	  (rounds (gethash "rounds" hash))
	  (table-scores (gethash "scores" hash))
	  (sport (gethash "sport" hash)))
      ;; (values  mode scores
      ;; 	       final-score)

      (list `(:score-table . nil)
	    `(:mode   . ,mode)
	    `(:sport  . ,sport)
	    `(:rounds . ,rounds)
	    `(:table . ,(hash->list table-scores))))))

(defmethod score->table ((person person))
  (let (
	(name (name person))
	(form (forms person))
	(final-score (final-score person))
	(score (score person))
	)
    (list `(:name . ,name)
	  `(:forms . ,form)
	  `(:score . ,score)
	  `(:final-score . ,final-score)
	  `(:total . ,(apply #'+ final-score)))))

