USING: io.encodings.utf8 kernel math.matrices
accessors strings 
    ;

IN: scorer

"! : TLCORNER ( -- x ) "

TUPLE: data-table
    rest
    { vbar     read-only
      initial: CHAR: \u002502 }
    { hbar     read-only
      initial: CHAR: \u002500 }
    { ulcorner read-only
      initial: CHAR: \u00250c }
    { blcorner read-only
      initial: CHAR: \u002514 }
    { urcorner read-only
      initial: CHAR: \u002510 }
    { brcorner read-only
      initial: CHAR: \u002518 }
    { left-t   read-only
      initial: CHAR: \u00251c }
    { right-t  read-only
      initial: CHAR: \u002524 }
    { up-t     read-only
      initial: CHAR: \u002538 }
    { down-t   read-only
      initial: CHAR: \u00252c }
    { mid-t    read-only
      initial: CHAR: \u00253c }
    ;

: <data-table> ( num -- table )
    data-table new
    swap >>rest ;

GENERIC: make-bar ( num obj -- str )

M: data-table make-bar ( num obj -- str ) hbar>> <string> ;
