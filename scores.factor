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

: reset-score-table ( -- ) score-table H{ } clone >>table
    "" >>file drop ;

: load-score-config ( file -- )
    score-table swap
    >>file dup file>> path>json >>table drop ;

: int-score ( val -- res )
    "scores" score-table table>> at at ;

HELP: int-score
{ $values { "val" object } { "res" object } }
{ $description "Takes a val and returns the defined value on the stack" }
    ;



M: score-table-class at* ( at obj -- val f )
    table>> at* ;
