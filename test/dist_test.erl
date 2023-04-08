%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(dist_test).      
    
 
-export([start/0

	]).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

start()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    ok=setup(),
    ok=test_1(),
   
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    timer:sleep(2000),
  % init:stop(),
    ok.


%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
test_1()->
  io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    AllNodes=test_nodes:get_nodes(),
    [N1,N2,N3,_N4]=AllNodes,
    %% Init
  
      
 %   Ping=[{X1,X2,rpc:call(X1,net_adm,ping,[X2],5000)}||X1<-AllNodes,
%						 X2<-AllNodes,
%						 X1=/=X2],
 %   io:format("Ping ~p~n",[{Ping,?MODULE,?LINE}]),
  
  %% N1 ---------------------------------------------------------------------------------
    ok=rpc:call(N1,application,load,[dbetcd],5000),
    ok=rpc:call(N1,application,start,[dbetcd],5000),
    pong=rpc:call(N1,dbetcd,ping,[],5000),
    pong=rpc:call(N1,common,ping,[],5000),
    pong=rpc:call(N1,sd,ping,[],5000),
    pong=rpc:call(N1,log,ping,[],5000),
    ['c1@c50','do_test@c50']=lists:sort(rpc:call(N1,mnesia,system_info,[db_nodes],5000)),
    
    [schedule]=rpc:call(N1,db_lock,read_all,[],5000),
    true=rpc:call(N1,db_lock,is_open,[schedule,1000],5000),
    timer:sleep(500),
    false=rpc:call(N1,db_lock,is_open,[schedule,1000],5000),
    timer:sleep(600),
    true=rpc:call(N1,db_lock,is_open,[schedule,1000],5000),
    
    io:format("N1 dist OK! ~p~n",[{?MODULE,?LINE}]),
    timer:sleep(1050),

    %% N2 -----------------------------------------------------------------------------
    ok=rpc:call(N2,application,load,[dbetcd],5000),
    ok=rpc:call(N2,application,start,[dbetcd],5000),
    pong=rpc:call(N2,dbetcd,ping,[],5000),
    pong=rpc:call(N2,common,ping,[],5000),
    pong=rpc:call(N2,sd,ping,[],5000),
    pong=rpc:call(N2,log,ping,[],5000),
    ['c1@c50','c2@c50','do_test@c50']=lists:sort(rpc:call(N2,mnesia,system_info,[db_nodes],5000)),
    
    [schedule]=rpc:call(N2,db_lock,read_all,[],5000),
    true=rpc:call(N2,db_lock,is_open,[schedule,1000],5000),
    false=rpc:call(N1,db_lock,is_open,[schedule,1000],5000),
    timer:sleep(600),
    false=rpc:call(N2,db_lock,is_open,[schedule,1000],5000),
    timer:sleep(600),
    true=rpc:call(N1,db_lock,is_open,[schedule,1000],5000),
    false=rpc:call(N2,db_lock,is_open,[schedule,1000],5000),
    io:format("N2 dbetcd OK! ~p~n",[{?MODULE,?LINE}]),
    timer:sleep(1050),

  %% N3 -----------------------------------------------------------------------------------
    ok=rpc:call(N3,application,load,[dbetcd],5000),
    ok=rpc:call(N3,application,start,[dbetcd],5000),
    pong=rpc:call(N3,dbetcd,ping,[],5000),
    pong=rpc:call(N3,common,ping,[],5000),
    pong=rpc:call(N3,sd,ping,[],5000),
    pong=rpc:call(N3,log,ping,[],5000),
    ['c1@c50','c2@c50','c3@c50','do_test@c50']=lists:sort(rpc:call(N3,mnesia,system_info,[db_nodes],5000)),
    
    [schedule]=rpc:call(N3,db_lock,read_all,[],5000),
    true=rpc:call(N3,db_lock,is_open,[schedule,1000],5000),
    false=rpc:call(N1,db_lock,is_open,[schedule,1000],5000),
    false=rpc:call(N2,db_lock,is_open,[schedule,1000],5000),
    timer:sleep(600),
    false=rpc:call(N3,db_lock,is_open,[schedule,1000],5000),
    timer:sleep(600),
    true=rpc:call(N2,db_lock,is_open,[schedule,1000],5000),
    false=rpc:call(N1,db_lock,is_open,[schedule,1000],5000),
    false=rpc:call(N3,db_lock,is_open,[schedule,1000],5000),
    io:format("N3 dbetcd OK! ~p~n",[{?MODULE,?LINE}]),
    timer:sleep(3050),
  
 %% N4 -----------------------------------------------------------------------------------------
   %% kill N3 
    io:format("kill N3  ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    [schedule]=rpc:call(N3,db_lock,read_all,[],5000),
    true=rpc:call(N3,db_lock,is_open,[schedule,3000],5000),
    rpc:call(N3,init,stop,[],5000),
    true=vm:check_stopped_node(N3),
    false=rpc:call(N1,db_lock,is_open,[schedule,3000],5000),
    
    %% restart N3 
    {ok,N3}=test_nodes:start_slave("c3"),
    [rpc:call(N3,net_adm,ping,[N],5000)||N<-AllNodes],
    {ok,Cwd}=rpc:call(N3,file,get_cwd,[],5000),
    CommonEbin=filename:join(Cwd,"_build/default/lib/common/ebin"),
    SdEbin=filename:join(Cwd,"_build/default/lib/sd/ebin"),
    LogEbin=filename:join(Cwd,"_build/default/lib/log_provider/ebin"),
    DbEtcdEbin=filename:join(Cwd,"_build/default/lib/dbetcd/ebin"),
    [true,true,true,true]=[rpc:call(N3,code,add_patha,[Ebin],5000)||Ebin<-[CommonEbin,SdEbin,LogEbin,DbEtcdEbin]], 
    ok=rpc:call(N3,application,start,[dbetcd],5000), 
    pong=rpc:call(N3,dbetcd,ping,[],5000),
    io:format("N3 restarted  ~p~n",[{?MODULE,?LINE}]),

    false=rpc:call(N3,db_lock,is_open,[schedule,3000],5000),
    timer:sleep(3000),
    true=rpc:call(N3,db_lock,is_open,[schedule,3000],5000),
    
    

    io:format("restart N3 OK!  ~p~n",[{?MODULE,?LINE}]),

  

  init:stop(),
    timer:sleep(2000),

  ok.


%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------


setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ok=test_nodes:start_nodes(),
    {ok,Cwd}=file:get_cwd(),
    CommonEbin=filename:join(Cwd,"_build/default/lib/common/ebin"),
    true=filelib:is_dir(CommonEbin),
    [true,true,true,true]=[rpc:call(N,code,add_patha,[CommonEbin],5000)||N<-test_nodes:get_nodes()],    

    SdEbin=filename:join(Cwd,"_build/default/lib/sd/ebin"),
    true=filelib:is_dir(SdEbin),
    [true,true,true,true]=[rpc:call(N,code,add_patha,[SdEbin],5000)||N<-test_nodes:get_nodes()],   

    LogEbin=filename:join(Cwd,"_build/default/lib/log_provider/ebin"),
    true=filelib:is_dir(LogEbin),
    [true,true,true,true]=[rpc:call(N,code,add_patha,[LogEbin],5000)||N<-test_nodes:get_nodes()],    

    DbEtcdEbin=filename:join(Cwd,"_build/default/lib/dbetcd/ebin"),
    true=filelib:is_dir(DbEtcdEbin),
    [true,true,true,true]=[rpc:call(N,code,add_patha,[DbEtcdEbin],5000)||N<-test_nodes:get_nodes()],   
    
%    [rpc:call(N,code,add_patha,["test_ebin"],5000)||N<-test_nodes:get_nodes()],     
 %   [rpc:call(N,code,add_patha,["common/ebin"],5000)||N<-test_nodes:get_nodes()],     
  %  kuk=[rpc:call(N,application,start,[common],5000)||N<-test_nodes:get_nodes()], 
 %   [rpc:call(N,code,add_patha,["sd/ebin"],5000)||N<-test_nodes:get_nodes()],     
  %  [rpc:call(N,application,start,[sd],5000)||N<-test_nodes:get_nodes()], 
  %  kuk=[rpc:call(N,common,ping,[],5000)||N<-test_nodes:get_nodes()], 
  %  kuk=[rpc:call(N,sd,ping,[],5000)||N<-test_nodes:get_nodes()], 
    ok.
