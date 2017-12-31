(in-package :scorer)

;; (defclass score ()
;;   ;;the class that stores the score
;;   ((table             :accessor p-table)
;;    (score-table       :initform nil :accessor score-table)
;;    (score             :initform nil :accessor score)
;;    (rounds            :initform nil :reader   rounds)
;;    (parsed-score      :initform nil :accessor parsed-score)
;;    (final-score       :initform nil :accessor final-score)
;;    (running-score-val :initform nil :accessor running-score-val)
;;    (ret-table         :initform nil :accessor ret-table)
;;    (ret-table-str     :initform nil :accessor str-table)))

;; (defclass person (score)
;;   ((name     :initarg :name  :accessor name)
;;    (forms    :initarg :forms :accessor forms :initform nil)
;;    (ammount  :initform 0   :accessor p-ammount :allocation :class)
;;    (fromdb-p :initform nil :accessor   fromdb-p)))

;; (defclass scored-round ()
;;   ((people :accessor people :initform nil)
;;    (place  :accessor place  :initform "")
;;    (date   :accessor date   :initform (make-instance 'date))))

;; Moving away from oop, going to alists
