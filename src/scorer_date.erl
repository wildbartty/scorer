-module(scorer_date).

-export([today/0]).

today()->
    {X,_} = calendar:local_time(),
    X.
