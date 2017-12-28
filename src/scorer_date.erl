-module(scorer_date).

-export([today/0, now/0]).

today()->
    {X,_} = calendar:local_time(),
    X.

now() ->
    calendar:local_time().
