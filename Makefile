#	Makefile for rebar3 RELEASE 
all:
	rm -rf  *~ apps/dbetcd/src/*~ *~ apps/dbetcd/src/*.beam test/*.beam test/*~ erl_cra* config/*~;
	rm -rf _build ebin test_ebin;
	rm -rf common sd api;
	rm -rf Mnesia.* logs;
	rebar3 release;
	rm -rf _build*;
	git add  *;
	git commit -m $(m);
	git push;
	echo Ok there you go!make
build:
	rm -rf  *~ apps/dbetcd/src/*~ *~ apps/dbetcd/src/*.beam test/*.beam test/*~ erl_cra* config/*~;
	rm -rf common sd api;
	rm -rf Mnesia.* logs;
	rm -rf  _build/test; # A bugfix in rebar3 or OTP
	rm -rf  _build;
	rebar3 release;
	rm -rf _build*

clean:
	rm -rf  *~ apps/dbetcd/src/*~ *~ apps/dbetcd/src/*.beam test/*.beam test/*~ erl_cra* config/*~;
	rm -rf _build ebin test_ebin;
	rm -rf common sd api;
	rm -rf Mnesia.* logs;

prod:
	rm -rf  *~ apps/dbetcd/src/*~ *~ apps/dbetcd/src/*.beam test/*.beam test/*~ erl_cra* config/*~;
	rm -rf _build ebin test_ebin;
	rm -rf common sd api;
	rm -rf Mnesia.* logs;
	rebar3 as prod release;
	rebar3 as prod tar;
	rm  -rf /home/joq62/erlang/infra/api_repo/dbetcd.api;
	cp apps/dbetcd/src/*.api /home/joq62/erlang/infra/api_repo;
	mv _build/prod/rel/dbetcd/*.tar.gz ../release 

eunit:
	rm -rf  *~ apps/dbetcd/src/*~ *~ apps/dbetcd/src/*.beam test/*.beam test/*~ erl_cra* config/*~;
	rm -rf _build ebin test_ebin;
	rm -rf common sd api;
	rm -rf Mnesia.* logs;
	rebar3 release;
	mkdir api;
	cp apps/dbetcd/src/*.api api;
	mkdir test_ebin;
	erlc -I api -I /home/joq62/erlang/infra/api_repo -o test_ebin test/*.erl;
	erl -pa _build/default/lib/*/* -pa test_ebin -sname do_test -run $(m) start $(a) $(b) -setcookie $(c)
