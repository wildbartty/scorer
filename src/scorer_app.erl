%%%-------------------------------------------------------------------
%% @doc scorer_erl public API
%% @end
%%%-------------------------------------------------------------------

-module(scorer_app).

%% Application callbacks
-compile(export_all).

read_config(File)->
    {ok,Ret} = file:read_file(File),
    Ret.
    
