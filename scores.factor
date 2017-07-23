USING: accessors assocs hashtables io io.encodings.utf8 io.files
json.reader json.reader kernel math.matrices math.parser namespaces
sequences strings vectors hashtables ;

IN: scorer

TUPLE: score-table-class
    { table hashtable
      initial: H{ } }
    file
    ;

SYMBOL: score-table



: <score-table> ( -- table ) score-table-class new H{ } clone >>table
    "" >>file ;

: reset-score-table ( -- ) <score-table> score-table set ;

reset-score-table

: load-score-config ( file -- obj' )
    score-table get swap
    >>file dup file>> path>json >>table ;

: int-score ( val -- num )
    "scores" score-table get table>> at at ;
