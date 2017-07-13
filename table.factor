USING: io.encodings.utf8 kernel math.matrices
accessors strings io io.files vectors sequences
math.parser
    ;

IN: scorer

"! : TLCORNER ( -- x ) "

CONSTANT: vbar     CHAR: \u002502 
CONSTANT: hbar     CHAR: \u002500 
CONSTANT: ulcorner CHAR: \u00250c 
CONSTANT: blcorner CHAR: \u002514 
CONSTANT: urcorner CHAR: \u002510 
CONSTANT: brcorner CHAR: \u002518 
CONSTANT: left-t   CHAR: \u00251c 
CONSTANT: right-t  CHAR: \u002524 
CONSTANT: up-t     CHAR: \u002538 
CONSTANT: down-t   CHAR: \u00252c 
CONSTANT: mid-t    CHAR: \u00253c 

TUPLE: data-table
    dimensions
    data
    ;

: <data-table> ( num -- table )
    data-table new
    swap >>dimensions ;

GENERIC: make-bar ( num obj -- str )

M: data-table make-bar ( num obj -- str ) hbar>> <string> ;
