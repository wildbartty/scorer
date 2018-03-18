%%%-------------------------------------------------------------------
%%% @author  <wildbartty@cornerstone>
%%% @copyright (C) 2018, 
%%% @doc
%%%
%%% @end
%%% Created : 28 Jan 2018 by  <wildbartty@cornerstone>
%%%-------------------------------------------------------------------
-module(scorer_server).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

%%exported api
-export([stop/0, print/0, add_person/1]).

%%Db Stuff

-define(SERVER, ?MODULE).

-record(scorer_server, {person,
			ref = make_ref(),
			iteration = 0}).


-record(state, {people = [],
		ref
	       }).

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
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

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
init([]) ->
    init_db(),
    {ok, #state{ref = make_ref()}}.


init_db()->
    mnesia:create_schema([node()]),
    mnesia:start(),
    {Ret,Rea}  = mnesia:create_table(scorer_server, [{attributes, record_info(fields,scorer_server)},
						     {type, bag},
						     {ram_copies, [node()]}]),
    if (Ret =:= atomic) -> ok;
       true -> {Ret, Rea}
    end.

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
handle_call({make_person, Args}, _From, State) ->
    People = State#state.people,
    Person0 = scorer_person:make_person(Args),
    Person = #scorer_server{person = Person0, ref = make_ref()},
    {reply, Person, State#state{people = [Person | People]}, 20000};
handle_call(get_people, _From, State) ->
    {reply, State#state.people, State};
handle_call(_, _From, State) ->
    {noreply, State}.




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
    io:format("people ~p hi~n", [State]),
    {noreply,State,2000};
handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(timeout, State) ->
    commit(State),
    {noreply, State};
handle_info(Info, State) ->
    io:format("Unknown message received: ~p~n", [Info]),
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
    io:format("Hello world~n"),
    {ok, State}.


%%%===================================================================
%%% External api
%%%===================================================================

stop() ->
    %% stops the currently running server
    gen_server:stop(scorer_server).

print()->
    gen_server:cast(scorer_server, print).

add_person(Args) ->
    gen_server:call(scorer_server,{make_person, Args}).

%%%===================================================================
%%% Internal functions
%%%===================================================================

commit(State) ->
    io:format("hi fucker~n", []),
    ok.
