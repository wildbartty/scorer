
%%%-------------------------------------------------------------------
%%% @author Tommy <wildbartty@toto>
%%% @copyright (C) 2018, Tommy
%%% @doc
%%%
%%% @end
%%% Created : 17 Feb 2018 by Tommy <wildbartty@toto>
%%%-------------------------------------------------------------------
-module(scorer_table).

-behaviour(gen_server).

-import(proplists,[lookup/2]).

-include_lib("stdlib/include/qlc.hrl").

%% API
-export([start_link/1]).

%%-export([make_table/0,make_table/1]). %% makes tables

-export([store_table/1, read_table/1]). %% store in db

%%-export([initDB/0]).

%% -export([read_config/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, 
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(scorer_table, {date = scorer_date:today(), 
		       scores = [],
		       rounds = 0,
		       sport = [],
		       mode = [],
		      name = ""}).


%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(Table_name) ->
    gen_server:start_link(?MODULE, [Table_name],
			  []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([File]) ->
    initDB(),
    Table = make_table(File),
    process_flag(trap_exit, true),
    {ok, Table}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call({lookup, Val}, _From, State) ->
    Proplist = State#scorer_table.scores,
    Reply = lookup(iolist_to_binary(Val), Proplist),
    {reply, Reply, State};
handle_call(state, _From, State) ->
    {reply, State, State};
handle_call(test, _From, State) ->
    {noreply, State};
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast(print,State) ->
    io:format("~p~n", [State]),
    {noreply, State};
handle_cast(_Msg, State) ->
    {noreply, State}.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
%% terminate(shutdown, _State) ->
%%     supervisor:del
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================



initDB()->
    mnesia:create_schema([node()]),
    mnesia:start(),
    {Ret,Rea} = mnesia:create_table(scorer_table, [{attributes,
						    record_info(fields
							       ,scorer_table)},
						   {type, bag},
						   {disc_copies,
						    [node()]}]),
    if (Ret =:= atomic) -> ok;

       true -> {Ret, Rea}
    end.

%% json_bstr_to_str([Car | Cdr])->
%%     Head = fun
%% 	       (X) when is_binary(X) ->
%% 				     binary_to_list(X);
%% 	(X) -> X
%% 			     end,

%% Tail = fun
%% 	   (X) when is_binary(X) ->
%% 	       binary_to_list(X);
%% 	   (X) when is_list(X)->
%% 	       json_bstr_to_str(X);
%% 	   (X) -> X
%%        end,
%%     {Key, Val} = Car,
%%     json_bstr_to_str(Cdr,[{Head(Key),Tail(Val)}]) ;

%% json_bstr_to_str([])->
%%     [].

%% json_bstr_to_str([Car|Cdr],Acc)->
%%     Head = fun
%% 	       (X) when is_binary(X) ->
%% 				       binary_to_list(X);
%% 	(X) -> X
%% 			       end,

%% Tail = fun
%% 	   (X) when is_binary(X) ->
%% 	       binary_to_list(X);
%% 	   (X) when is_list(X)->
%% 	       json_bstr_to_str(X);
%% 	   (X) -> X
%%        end,
%% {Key, Val} = Car,
%% json_bstr_to_str(Cdr,[{Head(Key),Tail(Val)}|Acc]);

%% json_bstr_to_str([],Acc) ->
%%     Acc.

read_config(Getile)->
    {ok,Str} = file:read_file(Getile),
    jsx:decode(Str).


%% valid_config(Config)->
%%     Score = lookup(<<"scores">>,Config),
%%     Rounds = lookup(<<"rounds">>,Config),
%%     if
%% 	(Score /= none) andalso
%% 	(Rounds /= none) -> ok;
%% 	true -> bad
%%     end.



make_table(File)->
    Table = read_config(File),
    {_,Scorer_table} = lookup(<<"scores">>, Table),
    {_,Rounds} = lookup(<<"rounds">>,Table),
    {_,Mode} = lookup(<<"mode">>, Table),
    {_,Sport} = lookup(<<"sport">>,Table),
    #scorer_table{sport=Sport,rounds=Rounds,
		  mode = Mode, scores= Scorer_table,
		 name = File}.

store_table(X) when is_record(X, scorer_table) ->
    Write = fun () ->
		    mnesia:write(X)
	    end,
    mnesia:transaction(Write) .

read_table(#scorer_table{date = X})->
    Get = fun()->
		  mnesia:match_object(#scorer_table{_='_', date = X})
	  end,
    mnesia:activity(transaction,Get) .

find_from_date(X) when is_tuple(X) ->
    Get = fun()->
		  mnesia:match_object(#scorer_table{_='_', date = X})
	  end,
    mnesia:activity(transaction,Get) .

tables_at_year(Year) ->
    Get = fun() ->
		  qlc:eval(qlc:q(
			     [{Year1, Month, Day} ||
				 #scorer_table{
				    date = {Year1,Month,Day} } <-
				     mnesia:table(scorer_table),
				 Year1 =:= Year
			     ]))
	  end,
    Get_tables = fun(X) -> find_from_date(X) end,
    lists:usort(lists:flatten(lists:map(Get_tables,mnesia:activity(transaction,Get)))).
