USING: io.encodings.utf8 kernel math.matrices
accessors strings 
    ;

IN: scorer

TUPLE: person
    { name string
      initial: "bob" }
    ;

: <person> ( -- obj ) person new ;
