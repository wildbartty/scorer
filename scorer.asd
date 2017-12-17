;;;; scorer.asd

(asdf:defsystem #:scorer
  :description "Describe scorer here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :serial t
  :depends-on (:alexandria
	       :split-sequence
	       :cl-ppcre
	       :cl-json
	       :cl-yaml)
  :components ((:file "package")
	       (:file "class-definitions")
	       (:file "time")
	       (:file "score")
	       (:file "person")
	       (:file "db")
               ))

