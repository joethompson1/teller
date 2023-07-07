defmodule TellerApi.App do
    import TellerApi.Signin
    import TellerApi.MFA
    import TellerApi.MFAVerify
    import TellerApi.Account

    def login(device_id, username, password) do
        initial_header_state = [
            {"teller-mission", "accepted!"},
            {"user-agent", "Teller Bank iOS 2.0"},
            {"api-key", "HowManyGenServersDoesItTakeToCrackTheBank?"},
            {"device-id", device_id},
            {"r-token", ""},
            {"f-token", ""},
            {"s-token", ""},
            {"content-type", "application/json"},
            {"accept", "application/json"}
        ]

        initial_login_state = %{
            "username" => username,
            "password" => password,
        }

        case Process.whereis(TellerApi.State.Header) do
            nil -> 
                TellerApi.State.Header.start_link(initial_header_state)
                TellerApi.State.Login.start_link(initial_login_state)
                TellerApi.State.Body.start_link(initial_login_state)

            _pid ->

                TellerApi.State.Header.update_state(initial_header_state)
                TellerApi.State.Body.update_state(initial_login_state)
                TellerApi.State.Login.update_state(initial_login_state)
        end

        signin(initial_header_state, initial_login_state)

        curHeaderState = TellerApi.State.Header.get_state()
        {_r_token_key, r_token} = Enum.find(curHeaderState, fn {key, _value} -> key == "r-token" end)

        if (r_token == "") do
            IO.puts("Incorrect authentication details")
            :error
        else
            mfa()
            mfaVerify()
        end
    end


    def logout do
        case Process.whereis(TellerApi.State.Header) do
            nil -> 
                IO.puts("Not logged in.")
                :error

            _pid ->
                curHeaderState = TellerApi.State.Header.get_state()
                {_r_token_key, r_token} = Enum.find(curHeaderState, fn {key, _value} -> key == "r-token" end) || {"", ""}

                if (r_token == "") do
                    IO.puts("Not logged in.")
                    :error
                else
                    TellerApi.State.Header.update_state([])
                    TellerApi.State.Body.update_state({})
                    TellerApi.State.Login.update_state({})
                    IO.puts("Logged out.")
                end
        end
    end


    def account_details(account_id) do
        case Process.whereis(TellerApi.State.Header) do
            nil ->
                IO.puts("Login required.")
                :error

            _pid ->
                curHeaderState = TellerApi.State.Header.get_state()
                {_r_token_key, r_token} = Enum.find(curHeaderState, fn {key, _value} -> key == "r-token" end)

                if (r_token == "") do
                    IO.puts("Login required.")
                    :error
                else
                    request_account_details(account_id) 
                end
        end
    end


    def account_balance(account_id) do
        case Process.whereis(TellerApi.State.Header) do
            nil ->
                IO.puts("Login required.")
                :error

            _pid ->
                curHeaderState = TellerApi.State.Header.get_state()
                {_r_token_key, r_token} = Enum.find(curHeaderState, fn {key, _value} -> key == "r-token" end)

                if (r_token == "") do
                    IO.puts("Login required.")
                    :error
                else
                    request_account_balance(account_id) 
                end
        end
    end


    def account_transactions(account_id) do
        case Process.whereis(TellerApi.State.Header) do
            nil ->
                IO.puts("Login required.")
                :error

            _pid ->
                curHeaderState = TellerApi.State.Header.get_state()
                {_r_token_key, r_token} = Enum.find(curHeaderState, fn {key, _value} -> key == "r-token" end)

                if (r_token == "") do
                    IO.puts("Login required.")
                    :error
                else
                    request_account_transactions(account_id) 
                end
        end
    end

end
