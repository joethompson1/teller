defmodule TellerApi.App do
    import TellerApi.Signin
    import TellerApi.MFA
    import TellerApi.MFAVerify
    import TellerApi.Account


    def login do
        # device_id = IO.gets("Device ID: ") |> to_string() |> String.trim()
        res = signin()
        response = elem(res, 1)
        header = elem(res, 2)
        devices = handle_signin_response(response)

        resMFA = mfa(devices, header)
        _response = elem(resMFA, 1)
        header = elem(resMFA, 2)

        resMFSVerify = mfaVerify(header)
        _response = elem(resMFSVerify, 1)
        header = elem(resMFSVerify, 2)
        request_account_balance(header)
        IO.puts("")
    end

    def account_details do
        request_account_details()
    end

    defp handle_signin_response(response) do
        case response do
            %{"result" => "mfa_required", "data" => %{"devices" => devices}} ->
                devices

            _ ->
                # Handle other result values or error cases if needed
                IO.puts("Error: no devices found.")
                []
        end
    end
end
