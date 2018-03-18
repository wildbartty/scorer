-module(scorer_person).

-include_lib("stdlib/include/qlc.hrl").

-import(proplists, [lookup/2]).

-record(scorer_person, {date = {1970,1,1},
			score = [],
			name = <<>>, 
			forms = <<>>,
			sport = <<>>, 
			final_score = 0,
			time = 0}).

%% To decode a persons score, the scorer_table db is looked up and is matched based on
%% the date and the sport
-export([initDB/0]).

-export([make_person/0,make_person/1]).

-export([store_person/1]).

-export([people_at_date/1,people_by_name/1]).

-export([people_by_args/1]).

lookup(Key, List, Default) ->
    Ret = lookup(Key,List),
    case Ret of 
	none ->
	    Default;
	_ ->
	    {_, Val} = Ret,
	    Val
    end.

to_binary(Item) ->
    if
	is_list(Item) ->
	    list_to_binary(Item);
	true -> Item
    end.

make_person()->
    make_person([{name,list_to_binary(string:chomp(io:get_line("Whats the name?\n")))}]).

make_person(Args) ->
    Name = to_binary(lookup(name,Args,<<>>)),
    Date = lookup(date,Args,scorer_date:today()),
    Forms = lookup(forms,Args,[]),
    Person = #scorer_person{score=[],
		   date = Date,
		   name= Name,
		   forms= Forms
    },
    %% Fun = fun () -> loop(Person) end,
    %% spawn(Fun).
    %% This is an interface to be run by another server
    Person.

%% loop(Person) ->
%%      receive 
%% 	 {test, From} ->
%% 	     From ! hi,
%% 	     loop(Person)
%%      end.

initDB()->
    mnesia:create_schema([node()]),
    mnesia:start(),
    {Ret,Rea}  = mnesia:create_table(scorer_person, [{attributes, record_info(fields,scorer_person)},
				       {type, bag},
				       {disc_copies, [node()]}]),
    if (Ret =:= atomic) -> ok;
       true -> {Ret, Rea}
       end.

store_person(Person) when is_record(Person,scorer_person) ->
    Write = fun () ->
		    mnesia:write(Person)
	    end,
    mnesia:activity(transaction,Write).

people_by_args(Args) ->
    Name = to_binary(lookup(name, Args, '_')),
    Sport = lookup(sport, Args, '_'),
    Forms = lookup(forms, Args, '_'),
    Date = lookup(date, Args, '_'),
    Final_score = lookup(final_score, Args, '_'),
    Time = lookup(time, Args, '_'),
    Score = lookup(score, Args, '_'),
    
    Person = #scorer_person{name = Name, sport = Sport, forms = Forms,
		  date = Date, final_score = Final_score,
		  score = Score, time = Time},
    Fun = fun () -> 
		  mnesia:match_object(Person)
	  end,
    mnesia:activity(transaction, Fun).
    
people_at_date(Date) ->
    Get = fun ()->
		  mnesia:match_object(#scorer_person{_ = '_', date = Date})
	  end,
    mnesia:activity(transaction,Get).
    
people_by_name(Name) when is_list(Name) ->
    people_by_name(list_to_binary(Name));
people_by_name(Name) ->
    %% Get_list = fun () ->
    %% 		  qlc:eval(qlc:q(
    %% 			     [Name1 ||
    %% 				 #scorer_person{
    %% 				    name = Name1 } <- mnesia:table(scorer_person),
    %% 				 Name =:= Name1]))
    %% 	  end,
    %% Names = mnesia:activity(transaction,Get_list),
    %% Wrong approach
    Get_people = fun ()->
			 %% Match_spec = #scorer_person{name = '$1', date = '$2', _ = '_'},
			 %% Guard = {'=:=', '$1', Name},
			 %% Result = ['$1', '$2'],
			 %% mnesia:select(scorer_person, [{Match_spec, [Guard], [Result]}])
			 mnesia:match_object(#scorer_person{_ = '_', name = Name})
		 end,
    mnesia:activity(transaction,Get_people).
