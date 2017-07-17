USING: io.encodings.utf8 kernel math.matrices
accessors strings io io.files vectors sequences
math.parser json json.reader hashtables
    namespaces  ;
    

IN: scorer

TUPLE: person
    name
    score
    ;

SYMBOL: score-hash

32 <hashtable> score-hash set

GENERIC: get-name ( obj -- obj )

M: person get-name ( obj -- obj ) "Enter name\n" write flush 
    readln >>name ;

: <person> ( -- obj ) person new clone
    get-name V{ } >>score ;

GENERIC: get-score-in ( obj -- obj )

M: person get-score-in ( obj -- obj )
    dup score>> "Enter score\n" write flush
    readln swap push ;
