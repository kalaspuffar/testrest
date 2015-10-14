%% @doc Handler for /datetranslate endpoints
-module(datetranslate_handler).

-export(
  [ init/3
  , allowed_methods/2
  , content_types_accepted/2
  , resource_exists/2
  , info/3
  , terminate/3
  ]).

-export(
  [ handle_get/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COWBOY CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init(_Transport, Req, _Opts) ->
  case cowboy_req:method(Req) of
    {<<"GET">>, Req1} ->
      handle_get(Req1)
  end.

allowed_methods(_Req, _State) -> {}.

content_types_accepted(_Req, _State) -> {}.

resource_exists(Req, State) -> {false, Req, State}.

info(_Transport, _Req, _State) -> {}.

terminate(_Reason, _Req, _State) -> ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INTERNAL CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle_get(Req) ->
  {ok, Req1} =
    cowboy_req:chunked_reply(200, [{"content-type", <<"text/plain">>}], Req),
    cowboy_req:chunk(<<"Hello world\n">>, Req),
    ok = pg2:join(testrest_listeners, self()),

  {loop, Req1, {}}.
