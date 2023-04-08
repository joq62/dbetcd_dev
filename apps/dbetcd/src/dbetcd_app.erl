%%%-------------------------------------------------------------------
%% @doc template_provider public API
%% @end
%%%-------------------------------------------------------------------

-module(dbetcd_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    {ok,_}=dbetcd_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
