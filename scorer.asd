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
<<<<<<< HEAD
  :components
      (
       (:file "package")
       ;(:file "class-definitions")
       ;(:file "time")
       ;(:file "score")
       ;(:file "person")
       ;(:file "db")
=======
  :components ((:file "package")
	       ;(:file "class-definitions")
	       (:file "time")
	       (:file "person")
	       (:file "db")
>>>>>>> 2966b0bef13bee9b3dc5921456145d31f784ed9b
               ))

