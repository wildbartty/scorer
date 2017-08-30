USING: accessors assocs hashtables io io.encodings.utf8 io.files
json.reader json.reader kernel math.matrices math.parser namespaces
sequences strings vectors hashtables help help.markup help.syntax ;

IN: scorer.table

TUPLE: score-table-class
    { table hashtable
      initial: H{ } }
    file
    ;

: <score-table> ( -- table ) score-table-class new H{ } clone >>table
    "" >>file ;

! stores the data
: score-table ( -- x ) T{ score-table-class f H{ } f } ;


: reset-score-table ( -- ) score-table H{ } clone >>table
    ! resets the score table to initial value 
    "" >>file drop ;


: load-score-config ( file -- )
    ! puts the json file in the score-table
    score-table swap
    >>file dup file>> path>json >>table drop ;

: reload-score-config ( -- )
    ! reloads the score-config
    score-table file>> load-score-config ;

M: score-table-class at* ( at obj -- val f )
    table>> at* ;

: score-val ( val -- res )
    "scores" score-table at at ;


