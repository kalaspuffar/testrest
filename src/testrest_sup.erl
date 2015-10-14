-module(testrest_sup).
-behaviour(supervisor).

-export([start_link/0, start_listeners/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_listeners() ->
  Dispatch =
    cowboy_router:compile(
      [
        {'_',
          [
            {<<"/datetranslate">>, datetranslate_handler, []}
          ]
        }
      ]
    ),

  RanchOptions =
    [
        {port, 4000}
    ],
  CowboyOptions =
    [
        {env,       [{dispatch, Dispatch}]},
        {compress,  true},
        {timeout,   12000}
    ],

  cowboy:start_http(testrest_http, 20, RanchOptions, CowboyOptions).

init([]) ->
    Procs = [
        {testrest_http,
        {testrest_sup, start_listeners, []},
        permanent, 1000, worker, [testrest_sup]}
    ],

    ok = pg2:create(testrest_listeners),

    {ok, {{one_for_one, 1, 5}, Procs}}.
