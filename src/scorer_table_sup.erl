%%%-------------------------------------------------------------------
%%% @author Tommy <wildbartty@toto>
%%% @copyright (C) 2018, Tommy
%%% @doc
%%%
%%% @end
%%% Created : 16 Mar 2018 by Tommy <wildbartty@toto>
%%%-------------------------------------------------------------------
-module(scorer_table_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

-export([start_table/1, whereis/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart intensity, and child
%% specifications.
%%
%% @spec init(Args) -> {ok, {SupFlags, [ChildSpec]}} |
%%                     ignore |
%%                     {error, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->

    SupFlags = #{strategy => one_for_one,
		 intensity => 1,
		 period => 5},
    {ok, {SupFlags, []}}.

%%--------------------------------------------------------------------
%% @doc
%% Starts a child holding a table config
%%
%% @spec start_table(Table) -> ok, {error, Error}
%% @end
%%--------------------------------------------------------------------

start_table(Table)->
    ChildID = 
	{Table,
	 {scorer_table, start_link, [Table]},
	 transient,
	 4000,
	 worker,
	 [scorer_table]},
    supervisor:start_child(?SERVER, ChildID).

whereis(ID) ->
    List = supervisor:which_children(?SERVER),
    priv_whereis(List, ID).

%%%===================================================================
%%% Internal functions
%%%===================================================================

priv_whereis([], _) ->
    undefined;
priv_whereis(List, Id)->
    [Car | Cdr] = List,
    {Maybe, Pid, _,_} = Car,
    Test = string:equal(Maybe, Id),
    if Test ->
	    Pid;
       true ->
	    priv_whereis(Cdr, Id)
    end.
