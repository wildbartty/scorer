(in-package #:scorer)

(defvar *db* nil)

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
	  (scores (score score))
	  (final-score (final-score score))
	  (rounds (gethash "rounds" hash))
	  (table-scores (gethash "scores" hash))
	  (sport (gethash "sport" hash)))
      (values  mode scores
	       final-score)
      (list `(:final-score . ,final-score)
	    `(:scores . ,scores)
	    `(:table  . ,(make-score-table :sport sport
				       :mode mode
				       :rounds rounds
				       :scores (hash->list table-scores)))))))

(defmethod score->table ((person person))
  (let ((score  (call-next-method person))
	(name (name person))
	(form (forms person))
	)
    (list `(:name . ,name)
	  `(:forms . ,form)
	  `(:score . ,score))))

