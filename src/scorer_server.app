{application, scorer_server,
 [{description, "The scorer server application"},
  {vsn, "0.0.1"},
  {registered, [scorer_server_app]},
  {mod, { scorer_server_app, []}},
  {applications,
   [kernel,
    stdlib,
    sasl
   ]},
  {env,[]},
  {modules, []},

  {maintainers, []},
  {licenses, ["Apache 2.0"]},
  {links, []}
 ]}.