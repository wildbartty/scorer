USING: accessors hashtables io io.encodings.utf8 io.files json.reader
json.reader kernel math.matrices math.parser namespaces sequences
strings vectors ;

IN: scorer

TUPLE: score-table-class
    table
    file
    ;

GENERIC: reset-score-table ( obj -- obj )

M: score-table-class reset-score-table ( obj -- obj ) 32 <hashtable> >>table ;

GENERIC: load-score-config ( file obj -- obj ) 

M: score-table-class load-score-config ( file obj -- obj )
    swap >>file dup file>> utf8 file-contents json>
    >>table ;

GENERIC: int-score ( val obj -- num )

M: score-table-class int-score ( val obj -- num )
    table>> at ;
