
USING: sequences tools.test ;

IN: scorer.pp

: test-pp ( -- ) 
    { 20 } [ "eh" 20 pad length ] unit-test
    { 0 } [ -100 push-to-zero ] unit-test
    { 0 } [ 0 push-to-zero ] unit-test
    { 3 } [ 3 push-to-zero ] unit-test
    
    ;
