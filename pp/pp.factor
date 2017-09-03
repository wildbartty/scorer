USING: accessors arrays assocs hashtables help.markup help.syntax io
io.encodings.utf8 io.files json json.reader kernel locals math
math.functions.integer-logs math.matrices math.order math.parser
namespaces parser scorer.table sequences sorting strings vectors ;

IN: scorer.pp

CONSTANT: vbar     "\u002502" 
CONSTANT: hbar     "\u002500" 
CONSTANT: ulcorner "\u00250c" 
CONSTANT: blcorner "\u002514" 
CONSTANT: urcorner "\u002510" 
CONSTANT: brcorner "\u002518" 
CONSTANT: left-t   "\u00251c" 
CONSTANT: right-t  "\u002524" 
CONSTANT: up-t     "\u002538" 
CONSTANT: down-t   "\u00252c" 
CONSTANT: mid-t    "\u00253c" 

: mirror ( x y z -- z y x )
    swap rot ; inline

: spaces ( num -- str ) CHAR: space <string> ;

: push-to-zero ( num -- 0/num )
    dup 0 > [ ] [ drop 0 ] if 
    ;

: pad ( str num -- str' )
    over length - spaces append ;

: wrap-bar ( str -- str' )
    left-t right-t surround ;

: make-bar ( num -- str ) hbar <repetition> concat ;

: make-top ( arr -- str ) make-bar ulcorner prefix urcorner suffix ;

: make-mid-bar ( arr -- str )
    [ [ length make-bar ] map mid-t join wrap-bar ] map 
    !    dup length 1 - 0  mirror subseq
    !    left-t right-t surround
    ;

: make-in-bar ( arr -- str )
    [ vbar join vbar vbar surround "\n" append ] map
    ;

: make-table ( arr-of-arr -- str )
    [ [ make-in-bar ] map ] map 
    ;

TUPLE: data-table
    { dimensions array }
    { data hashtable }
    data-dimensions
    ;

INSTANCE: data-table assoc

! first dimensions is the col
! second dimensions is the row

: <data-table> ( num num -- table )
    2array
    data-table new
    swap >>dimensions ;

GENERIC: add-row ( obj -- obj' )

M: string add-row dup length 1 - spaces vbar prefix "\n" prepend
    vbar suffix append ;

M: data-table add-row ( obj -- obj' )
    dup dimensions>> dup second 1 + 1 rot set-nth ;

GENERIC: add-col ( obj -- obj' )

M: data-table add-col ( obj -- obj' )
    dup dimensions>> dup first 1 + 0 rot set-nth ;
