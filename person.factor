USING: accessors hashtables io io.encodings.utf8 io.files json
json.reader kernel math.matrices math.parser namespaces parser
sequences strings vectors ;
    

IN: scorer

TUPLE: person
    name
    score-arr
    val-arr
    ;

: init ( -- ) "~/projects/scorer/table.factor" run-file ;

GENERIC: get-name ( obj -- obj )

M: person get-name ( obj -- obj ) "Enter name\n" write flush 
    readln >>name ;

: <person> ( -- obj ) person new clone
    get-name V{ } >>score-arr ;

GENERIC: get-score-in ( obj -- obj )

M: person get-score-in ( obj -- obj )
    dup score-arr>> "Enter score\n" write flush
    readln swap push ;

GENERIC: get-score-vals ( obj -- obj )
