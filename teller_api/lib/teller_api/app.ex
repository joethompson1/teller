defmodule TellerApi.App do
    import TellerApi.Signin
    import TellerApi.MFA

    def start do
        # device_id = IO.gets("Device ID: ") |> to_string() |> String.trim()
        res = signin()  # Pass the deviceId to the signin function
        IO.inspect(res)
        response = elem(res, 1)

        header = elem(res, 2)

        devices = handle_signin_response(response)
        mfaResponse = mfa(devices, header)
        IO.inspect(mfaResponse)
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
