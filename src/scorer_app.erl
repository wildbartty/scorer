%%%-------------------------------------------------------------------
%% @doc scorer_erl public API
%% @end
%%%-------------------------------------------------------------------

-module(scorer_app).

%% Application callbacks
-compile(export_all).

json_bstr_to_str([Car | Cdr])->
    Head = fun
	       (X) when is_binary(X) ->
		   binary_to_list(X);
	       (X) -> X
	   end,
    
    Tail = fun
	       (X) when is_binary(X) ->
		   binary_to_list(X);
	       (X) when is_list(X)->
		   json_bstr_to_str(X);
	       (X) -> X
	   end,
    {Key, Val} = Car,
    [{Head(Key),Tail(Val)}|json_bstr_to_str(Cdr)] ;

json_bstr_to_str([])->
    [].

read_config(File)->
    {ok,Str} = file:read_file(File),
    Ret = jsx:decode(Str),
    json_bstr_to_str(Ret).
