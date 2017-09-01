USING: accessors arrays assocs hashtables help.markup help.syntax io
io.encodings.utf8 io.files json json.reader kernel locals math
math.functions.integer-logs math.matrices math.order math.parser
namespaces parser scorer.table sequences sorting strings vectors ;
    

IN: scorer

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

: spaces ( num -- str: array ) CHAR: space <string> ; inline

: wrap-bar ( str -- str' ) 
    left-t right-t surround ; inline

: make-bar ( num -- str ) hbar <repetition> concat ;

: make-top ( arr -- str ) make-bar ulcorner prefix urcorner suffix ;

: make-mid-bar ( arr -- str )
    [ length make-bar ] map mid-t join wrap-bar
!    dup length 1 - 0  mirror subseq
!    left-t right-t surround
    ;

: make-in-bar ( arr -- str )
    vbar join vbar vbar surround "\n" append
    ;
    
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

CONSTANT: person-map H{ }

CONSTANT: curr-date V{ } 

CONSTANT: person-list V{ }

: true? ( obj -- t/f )
    t and ;

: ask-input ( str -- str )
   write flush readln ; 

: init ( -- ) "~/projects/scorer/table.factor" run-file ;

: get-name ( -- obj ) "Enter name\n" ask-input ;

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
    dup person-list push
    ;

GENERIC: get-score-in ( obj -- obj )

M: person get-score-in ( obj -- obj )
    dup score-arr>> "Enter score\n" ask-input swap push ;

GENERIC: get-score-vals ( obj -- obj )

! M: person get-score-vals ( obj -- obj' )
!   [let dup score-arr>> [ score-val ] map :> x
!    x >>val-arr ]
!   ;

! M: person get-score-vals ( obj -- obj' obj obj )
!    dup [ val-arr>> ] [ score-arr>> ] bi clone
!    dup pop swapd score-val [ over push ] [ ] if
!    ; 

: sum-subseq ( from to seq -- num )
   subseq sum ; 

: get-accumulation ( vec -- vec )
    clone
    [let V{ } :> val
     dup sum val push ]
    ;

GENERIC: write-score ( obj -- obj )
M: person write-score ( obj -- obj )
    dup drop ;
    
: check-score ( val -- bool )
    !    score-val t and
    ;

GENERIC: score-round ( obj -- obj' )

M: person score-round ( person -- person' )
    0 >>current-round
    [ dup [ rounds>> ] [ current-round>> ] bi <= ]
    [ get-score-in [ 1 + ] change-current-round ]
    until
!   get-score-vals
    ;

GENERIC: edit-score ( a b -- b )
M: person edit-score 
    dup swapd score-arr>>
    "Enter new score\n" ask-input
    -rot set-nth
    ;

: mag ( no -- mag )
    integer-log10 ;

: get-longest ( seq -- elt )
    [ [ length ] compare ] sort
    first ;

: ?biggest ( n m -- n/m )
    2dup > -rot ? ;
    
: ?longest ( seq1 seq2 -- seq )
    2dup [ length ] bi@ > -rot ? ; 

: val-lenc ( -- len )
    "scores" score-table at keys get-longest "score" ?longest
 ;

: len-no ( rounds -- len )
    mag "no." length ?biggest ;

GENERIC: person>string ( person -- str )

M: person person>string ( person -- str )
    [let clone :> person person name>> clone :> name
     person val-arr>> clone :> val-arr
     person score-arr>> clone :> score-arr
     person rounds>> clone :> rounds
     rounds len-no :> rounds-len
     val-lenc :> val-length

     name ]

    ;

: finish-round ( -- )
    ;

! : numeric-for ( x elt --  newelt )
!    over - <iota> [ over  + ] map nip
!    ; 
    
