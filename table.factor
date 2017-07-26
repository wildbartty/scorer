USING: accessors arrays assocs hashtables io io.encodings.utf8
io.files json json.reader kernel math math.matrices math.parser
namespaces parser sequences strings vectors ;

IN: scorer

! : TLCORNER ( -- x ) "

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
    { dimensions array }
    { data vector }
    data-dimensions
    ;

! first dimensions is the col
! second dimensions is the row

: <data-table> ( num num -- table )
    2array
    data-table new
    swap >>dimensions ;

GENERIC: make-bar ( num -- str )

M: data-table make-bar ( num -- str ) hbar <string> ;

GENERIC: add-row ( obj -- obj' )

M: data-table add-row ( obj -- obj' )
    dup dimensions>> dup second 1 + 1 rot set-nth ;

GENERIC: add-col ( obj -- obj' )

M: data-table add-col ( obj -- obj' )
    dup dimensions>> dup first 1 + 0 rot set-nth ;
