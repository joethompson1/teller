defmodule TellerApi.App do
    import TellerApi.Signin
    import TellerApi.MFA
    import TellerApi.MFAVerify
    import TellerApi.Account

    def login do
        # device_id = IO.gets("Device ID: ") |> to_string() |> String.trim()
        # username = IO.gets("Username: ") |> to_string() |> String.trim()
        # password = IO.gets("Password: ") |> to_string() |> String.trim()
        # IO.puts("")

        initial_header_state = [
            {"teller-mission", "accepted!"},
            {"user-agent", "Teller Bank iOS 2.0"},
            {"api-key", "HowManyGenServersDoesItTakeToCrackTheBank?"},
            {"device-id", "SM22X3DIAPKGRGUJ"},
            {"r-token", ""},
            {"f-token", ""},
            {"s-token", ""},
            {"content-type", "application/json"},
            {"accept", "application/json"}
        ]

        initial_login_state = %{
            "username" => "green_lucky",
            "password" => "papuanewguinea",
        }
        
        TellerApi.State.Header.start_link(initial_header_state)
        TellerApi.State.Login.start_link(initial_login_state)
        TellerApi.State.Body.start_link(initial_login_state)

        signin()

        mfa()

        mfaVerify()
        IO.puts("Successfully logged in!")
    end

    def account_balance do
        case Process.whereis(TellerApi.State.Header) do
            nil ->
                IO.puts("Login required.")
                :error

            _pid ->
                request_account_balance() 
        end
    end

end
