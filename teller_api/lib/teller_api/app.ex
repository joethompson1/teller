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
            {"content-type", "application/json"},
            {"accept", "application/json"}
        ]

        initial_login_state = %{
            "username" => "green_lucky",
            "password" => "papuanewguinea",
        }
        
        {:ok, _} = TellerApi.HeaderState.start_link(initial_header_state)

        {:ok, _} = TellerApi.LoginState.start_link(initial_login_state)

        {:ok, _} = TellerApi.BodyState.start_link(initial_login_state)


        signin()

        mfa()

        mfaVerify()
        # _response = elem(resMFSVerify, 1)
        # header = elem(resMFSVerify, 2)
        # request_account_balance(header)
        IO.puts("")
    end

    # def account_details do
    #     request_account_details()
    # end

end
