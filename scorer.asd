;;;; scorer.asd

(asdf:defsystem #:scorer
  :description "Describe scorer here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :serial t
  :depends-on (:alexandria
	       :split-sequence
	       :cl-yaml)
  :components ((:file "package")
	       (:file "person")
               (:file "scorer")))

