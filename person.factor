USING: io.encodings.utf8 kernel math.matrices
accessors strings io io.files vectors sequences
math.parser
    ;

IN: scorer

TUPLE: person
    { name string
      initial: "bob" }
    { score vector
      initial: V{ } }
    ;

: <person> ( -- obj ) person new ;

GENERIC: get-name ( obj -- obj )

M: person get-name ( obj -- obj ) "Enter name\n" write flush 
    readln >>name ;

GENERIC: get-score-in ( obj -- obj )

M: person get-score-in ( obj -- obj )
    dup score>> "Enter score\n" write flush
    readln hex> swap push ;
