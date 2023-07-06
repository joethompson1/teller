defmodule TellerApi.App do
    import TellerApi.Signin
    import TellerApi.MFA
    import TellerApi.MFAVerify
    import TellerApi.Account


    @initial_header_state [
        {"teller-mission", "accepted!"},
        {"user-agent", "Teller Bank iOS 2.0"},
        {"api-key", "HowManyGenServersDoesItTakeToCrackTheBank?"},
        {"device-id", "SM22X3DIAPKGRGUX"},
        {"r-token", ""},
        {"f-token", ""},
        {"s-token", ""},
        {"content-type", "application/json"},
        {"accept", "application/json"}
    ]

    @initial_login_state %{
        "username" => "green_lucky",
        "password" => "papuanewguinea",
    }

    def login do
        # device_id = IO.gets("Device ID: ") |> to_string() |> String.trim()
        # username = IO.gets("Username: ") |> to_string() |> String.trim()
        # password = IO.gets("Password: ") |> to_string() |> String.trim()
        # IO.puts("")
        
        TellerApi.State.Header.start_link(@initial_header_state)
        TellerApi.State.Login.start_link(@initial_login_state)
        TellerApi.State.Body.start_link(@initial_login_state)

        signin(@initial_header_state, @initial_login_state)

        curHeaderState = TellerApi.State.Header.get_state()
        {_r_token_key, r_token} = Enum.find(curHeaderState, fn {key, _value} -> key == "r-token" end)

        if (r_token == "") do
            IO.puts("Incorrect authentication details")
            :error
        else
            mfa()
            mfaVerify()
            IO.puts("Successfully logged in!")
        end
    end


    def logout do
        case Process.whereis(TellerApi.State.Header) do
            nil -> 
                IO.puts("Not logged in.")
                :error

            _pid ->
                curHeaderState = TellerApi.State.Header.get_state()
                {_r_token_key, r_token} = Enum.find(curHeaderState, fn {key, _value} -> key == "r-token" end)

                if (r_token == "") do
                    IO.puts("Not logged in.")
                    :error
                else
                    TellerApi.State.Header.update_state(@initial_header_state)
                    TellerApi.State.Body.update_state(@initial_login_state)
                    TellerApi.State.Login.update_state(@initial_login_state)
                    IO.puts("Logged out.")
                end
        end
    end


    def account_balance do
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
                    request_account_balance() 
                end
        end
    end

end
