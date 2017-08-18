USING: accessors assocs hashtables io io.encodings.utf8 io.files
json.reader json.reader kernel math.matrices math.parser namespaces
sequences strings vectors hashtables help help.markup help.syntax ;

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

HELP: int-score
{ $values { "val" object } { "res" object } }
{ $description "Takes a val and returns the defined value" }
    ;


