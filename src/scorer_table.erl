-module(scorer_table).

-import(proplists,[lookup/2]).

-export([make_table/0,make_table/1]). %% makes tables

-export([store_table/1, read_table/1]). %% store in db

-export([initDB/0]).

-export([read_config/1]).

-record(scorer_table, {date = scorer_date:today(), 
		       scores = [],
		       rounds = 0,
		       sport = [],
		       mode = []}).


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

read_config(File)->
    {ok,Str} = file:read_file(File),
    Ret = jsx:decode(Str),
    json_bstr_to_str(Ret).

valid_config(Config)->
    %% check that all the data to score a round is in the file
    Score = lookup("scores",Config),
    Rounds = lookup("rounds",Config),
    if
	(Score == none) -> {bad, score};
	Rounds == none -> {bad, rounds};
	true -> {ok, Config}
    end.

initDB()->
    mnesia:create_schema([node()]),
    mnesia:start(),
    {Ret,Rea}  = mnesia:create_table(scorer_table, [{attributes, record_info(fields,scorer_table)},
						    {type, bag},
						    {disc_copies, [node()]}]),
    if (Ret =:= atomic) -> ok;

       true -> {Ret, Rea}
    end.

make_table()->
    make_table("test.json"). %% Default config to load

make_table(File)->
    Table = read_config(File),
    {ok,Check} = valid_config(Table),
    if
	not (is_atom(Check)) ->
	    {_,Scorer_table} = lookup("scores", Table),
	    {_,Rounds} = lookup("rounds",Table),
	    {_,Mode} = lookup("mode", Table),
	    {_,Sport} = lookup("sport",Table),
	    #scorer_table{sport=Sport,rounds=Rounds,
			  mode = Mode, scores= Scorer_table};
	true -> Check
    end.

store_table(X) when is_record(X, scorer_table) ->
    F = fun () ->
		mnesia:write(X)
	end,
    mnesia:transaction(F) .

read_table(#scorer_table{date = X})->
    F = fun()->
		mnesia:match_object(#scorer_table{_='_', date = X})
	end,
    mnesia:activity(transaction,F) .