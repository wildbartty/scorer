%%%-------------------------------------------------------------------
%% @doc scorer_erl public API
%% @end
%%%-------------------------------------------------------------------

-module(scorer_app).

-import_lib("stdlib/include/qlc").

-import(proplists,[lookup/2]). %% used to read json data

%% Application callbacks
-export([read_config/1, make_person/0,
	 read_config/0,
	 initDB/0]).


-record(scorer_person, {date = 0,
			score = [],
			name = [], 
			forms = [],
			time = 0}).

-record(scorer_round, {people = [],
		       time = 0,
		       scorer_table = scorer_table:make_table()}).

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
    json_bstr_to_str(Cdr,[{Head(Key),Tail(Val)}]) ;

json_bstr_to_str([])->
    [].

json_bstr_to_str([Car|Cdr],Acc)->
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
    json_bstr_to_str(Cdr,[{Head(Key),Tail(Val)}|Acc]);

json_bstr_to_str([],Acc) ->
    Acc.

read_config()->
    read_config("test.json").

read_config(File)->
    {ok,Str} = file:read_file(File),
    Ret = jsx:decode(Str),
    json_bstr_to_str(Ret).

make_person()->
    #scorer_person{score=[],
	      name= string:chomp(io:get_line("Whats the name?\n")),
	      forms= []
	     
    }.

initDB()->
    mnesia:create_schema([node()]),
    mnesia:start(),
    {Ret,Rea}  = mnesia:create_table(scorer_person, [{attributes, record_info(fields,scorer_person)},
				       {type, bag},
				       {disc_copies, [node()]}]),
    if (Ret =:= atomic) -> ok;
     
       true -> {Ret, Rea}
       end.
    
	

