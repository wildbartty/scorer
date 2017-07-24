USING: accessors assocs hashtables io io.encodings.utf8 io.files json
json.reader kernel math.matrices math.parser namespaces parser
sequences strings vectors ;
    

IN: scorer

TUPLE: person
    name
    table
    sport
    mode
    rounds
    { score-arr vector }
    { val-arr vector }
    ;

: init ( -- ) "~/projects/scorer/table.factor" run-file ;

: get-name ( -- obj ) "Enter name\n" write flush 
    readln ;

GENERIC: person-at ( name obj -- hash-res )

M: person at* table>> at* ;

: <person> ( -- obj )
    person new
    get-name >>name
    score-table table>> >>table
    dup table>> "sport" swap at >>sport
    dup table>> "mode" swap at >>mode
    dup table>> "rounds" swap at >>rounds

    ;

GENERIC: get-score-in ( obj -- obj )

M: person get-score-in ( obj -- obj )
    dup score-arr>> "Enter score\n" write flush
    readln swap push ;

GENERIC: get-score-vals ( obj -- obj )

M: person get-score-vals ( obj -- obj' )
    dup score-arr>> [ int-score ] map >>val-arr ;
