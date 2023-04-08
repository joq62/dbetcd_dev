%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2023, c50
%%% @doc
%%%
%%% @end
%%% Created : 15 Mar 2023 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(dbetcd).

-include("log.api").

-define(SERVER,dbetcd_server).

%% API
-export([
	 %% Provider
	% TO_BE_CHANGED_Functions
	 
	 %% 
	 ping/0,
	 ping/1

	]).


%% Leader API
-export([
	 
	]).

-export([
	 start/0,
	 stop/0,
	 start/1,
	 stop/1
	]).


%%%===================================================================
%%% API
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
cahnge(Args,{SenderNode,SenderPid,Module,FunctionName,Line,TimeStamp})->
    io:format("Time: ~p~n",[calendar:now_to_datetime(erlang:timestamp())]),
    io:format("Sender: ~p~n",[{SenderNode,SenderPid,Module,FunctionName,Line,TimeStamp}]),
    io:format("Input: ~p~n",[{?MODULE,?FUNCTION_NAME,[Args]}]),
    T1=os:system_time(millisecond),
    Result=change(Args),
    T2=os:system_time(millisecond),
    io:format("Output: ~p~n",[{?MODULE,?FUNCTION_NAME,[Result]}]),
    io:format("Exection time (ms): ~p~n~n",[T2-T1]),
    Result.

change(Args)->
    gen_server:call(?SERVER, {change,Args},infinity).


%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
start({SenderNode,SenderPid,Module,FunctionName,Line,TimeStamp})->
   ?LOG_NOTICE("Start gen_server",[]),
    io:format("Time: ~p~n",[calendar:now_to_datetime(erlang:timestamp())]),
    io:format("Sender: ~p~n",[{SenderNode,SenderPid,Module,FunctionName,Line,TimeStamp}]),
    io:format("Input: ~p~n",[{?MODULE,?FUNCTION_NAME,[]}]),
    T1=os:system_time(millisecond),
    Result=start(),
    T2=os:system_time(millisecond),
    io:format("Output: ~p~n",[{?MODULE,?FUNCTION_NAME,[Result]}]),
    io:format("Exection time (ms): ~p~n~n",[T2-T1]),
    Result.

start()->
    gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).
    
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
stop({SenderNode,SenderPid,Module,FunctionName,Line,TimeStamp})->
    io:format("Time: ~p~n",[calendar:now_to_datetime(erlang:timestamp())]),
    io:format("Sender: ~p~n",[{SenderNode,SenderPid,Module,FunctionName,Line,TimeStamp}]),
    io:format("Input: ~p~n",[{?MODULE,?FUNCTION_NAME,[]}]),
    T1=os:system_time(millisecond),
    Result=stop(),
    T2=os:system_time(millisecond),
    io:format("Output: ~p~n",[{?MODULE,?FUNCTION_NAME,[Result]}]),
    io:format("Exection time (ms): ~p~n~n",[T2-T1]),
    Result.

stop()->
    gen_server:call(?SERVER, {stop},infinity).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
ping({SenderNode,SenderPid,Module,FunctionName,Line,TimeStamp})->
    ?LOG_NOTICE("ping",[]),
    io:format("Time: ~p~n",[calendar:now_to_datetime(erlang:timestamp())]),
    io:format("Sender: ~p~n",[{SenderNode,SenderPid,Module,FunctionName,Line,TimeStamp}]),
    io:format("Input: ~p~n",[{?MODULE,?FUNCTION_NAME,[]}]),
    T1=os:system_time(millisecond),
    Result=ping(),
    T2=os:system_time(millisecond),
    io:format("Output: ~p~n",[{?MODULE,?FUNCTION_NAME,[Result]}]),
    io:format("Exection time (ms): ~p~n~n",[T2-T1]),
    Result.

ping()->
    gen_server:call(?SERVER, {ping},infinity).


%%%===================================================================
%%% Internal functions
%%%===================================================================

