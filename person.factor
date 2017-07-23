USING: accessors assocs hashtables io io.encodings.utf8 io.files json
json.reader kernel math.matrices math.parser namespaces parser
sequences strings vectors ;
    

IN: scorer

TUPLE: person
    name
    sport
    table
    mode
    rounds
    { score-arr vector }
    { val-arr vector }
    ;

: init ( -- ) "~/projects/scorer/table.factor" run-file ;

GENERIC: get-name ( obj -- obj )

M: person get-name ( obj -- obj ) "Enter name\n" write flush 
    readln >>name ;

GENERIC: person-at ( name obj -- hash-res )

M: person person-at table>> at ;

: <person> ( -- obj )
    person new clone
    get-name
    V{ } >>score-arr
    score-table get table>> >>table
    "rounds" over person-at >>rounds
    "mode" over person-at >>mode
    "sport" over person-at >>sport
    ;

GENERIC: get-score-in ( obj -- obj )

M: person get-score-in ( obj -- obj )
    dup score-arr>> "Enter score\n" write flush
    readln swap push ;

GENERIC: get-score-vals ( obj -- obj )

M: person get-score-vals ( obj -- obj' )
    dup score-arr>> [ int-score ] map >>val-arr ;
