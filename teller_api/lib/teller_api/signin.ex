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

        case response do
            {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
                # Successful response
                status_code = 200
                status_text = get_status_text(status_code)
                IO.puts("#{status_code} #{status_text}")
                decoded_body = Poison.decode!(response_body)
                outputResponse(response_headers)
                IO.puts(Poison.encode!(decoded_body, pretty: true) <> "\n")
                {:ok, decoded_body, response_headers}  # Return decoded response and headers

            {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
                # Handle other response codes
                status_text = get_status_text(status_code)
                IO.puts("#{status_code} #{status_text}")
                {:error, {status_code, response_body}, response_headers}

            {:error, error} ->
                # Handle request error
                {:error, error, response_headers}
        end
    end
end
