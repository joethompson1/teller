{application,teller_api,
             [{optional_applications,[]},
              {applications,[kernel,stdlib,elixir,logger,crypto,httpoison,
                             poison]},
              {description,"teller_api"},
              {modules,['Elixir.TellerAPI.Utils.Response',
                        'Elixir.TellerAPI.Utils.Token',
                        'Elixir.TellerApi.Account','Elixir.TellerApi.App',
                        'Elixir.TellerApi.MFA','Elixir.TellerApi.MFAVerify',
                        'Elixir.TellerApi.Signin',
                        'Elixir.TellerApi.State.Body',
                        'Elixir.TellerApi.State.Header',
                        'Elixir.TellerApi.State.Login']},
              {registered,[]},
              {vsn,"0.1.0"}]}.
