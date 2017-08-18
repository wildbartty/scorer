USING: accessors assocs hashtables help.markup help.syntax io
io.encodings.utf8 io.files json json.reader kernel math math.matrices
math.parser namespaces parser sequences strings vectors ;
    

IN: scorer

TUPLE: score-table-class
    { table hashtable
      initial: H{ } }
    file
    ;



: <score-table> ( -- table ) score-table-class new H{ } clone >>table
    "" >>file ;


CONSTANT: score-table T{ score-table-class
                         f H{ } f }

! a constant word that is used to store the
! configs for the scorer

: reset-score-table ( -- ) score-table H{ } clone >>table
    ! self-descriptive, resets score-table to it's inital
    ! state
    "" >>file drop ;


: load-score-config ( file -- )

    score-table swap
    >>file dup file>> path>json >>table drop ;

: reload-score-config ( -- )
    ! reloads the score-config
    score-table file>> load-score-config ;

M: score-table-class at* ( at obj -- val f )
    table>> at* ;

: int-score ( val -- res )
    "scores" score-table at at ;

CONSTANT: person-map H{ }
CONSTANT: curr-date V{ } 

TUPLE: person
    name
    table
    sport
    mode
    rounds
    { score-arr vector }
    { val-arr vector }
    current-round
    ;

: init ( -- ) "~/projects/scorer/table.factor" run-file ;

: get-name ( -- obj ) "Enter name\n" write flush 
    readln ;

M: person at* table>> at* ;

: <person> ( -- obj )
    person new
    get-name >>name
    score-table table>> >>table
    dup table>> "sport" swap at >>sport
    dup table>> "mode" swap at >>mode
    dup table>> "rounds" swap at >>rounds
    0 >>current-round
    V{ } >>score-arr
    V{ } >>val-arr
    ;

GENERIC: get-score-in ( obj -- obj )

M: person get-score-in ( obj -- obj )
    dup score-arr>> "Enter score\n" write flush
    readln swap push ;

! GENERIC: get-score-vals ( obj -- obj  obj obj )
! 
! M: person get-score-vals ( obj -- obj' obj obj )
!    dup [ val-arr>> ] [ score-arr>> ] bi clone
!    dup pop swapd int-score [ over push ] [ ] if
!    ; 


GENERIC: write-score ( obj -- obj )

M: person write-score ( obj -- obj )
    dup drop ;
    
GENERIC: score-round ( obj -- obj' )



M: person score-round ( person -- person' )
    [ dup [ rounds>> ] [ current-round>> ] bi <= ]
    [ get-score-in [ 1 + ] change-current-round ]
    until
!   get-score-vals
    ;

! : numeric-for ( start limit body: ( ..a -- ..b) -- ..b )
!   2dup 
!    ;
    
