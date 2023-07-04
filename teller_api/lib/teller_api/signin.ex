defmodule TellerApi.Signin do
    use HTTPoison.Base
    import TellerAPI.Utils.ResponseUtils

    @base_url "https://test.teller.engineering"

    def signin() do
        device_id = Application.get_env(:teller_api, :device_id)

        url = "#{@base_url}/signin"
        headers = [
            {"user-agent", "Teller Bank iOS 2.0"},
            {"api-key", "HowManyGenServersDoesItTakeToCrackTheBank?"},
            {"device-id", device_id},  # Add the device_id to the headers
            {"content-type", "application/json"},
            {"accept", "application/json"}
        ]
        body = %{
            "password" => "papuanewguinea",
            "username" => "green_lucky"
        }

        IO.puts("POST /signin")
        outputResponse(headers)
        IO.puts(Poison.encode!(body, pretty: true) <> "\n")


        response = post(url, Poison.encode!(body), headers)
        {:ok, unpacked} = response
        response_headers = unpacked.headers

        handle_response(response, response_headers)
    end
end
