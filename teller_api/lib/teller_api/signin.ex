defmodule TellerApi.Signin do
    use HTTPoison.Base

    @base_url "https://test.teller.engineering"

    def signin() do
        device_id = Application.get_env(:teller_api, :device_id)

        url = "#{@base_url}/signin"
        headers = [
            {"User-Agent", "Teller Bank iOS 2.0"},
            {"api-key", "HowManyGenServersDoesItTakeToCrackTheBank?"},
            {"device-id", device_id},  # Add the device_id to the headers
            {"Content-Type", "application/json"},
            {"Accept", "application/json"}
        ]
        body = %{
            "password" => "papuanewguinea",
            "username" => "green_lucky"
        }

        response = post(url, Poison.encode!(body), headers)
        {:ok, unpacked} = response
        response_headers = unpacked.headers

        case response do
            {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
                # Successful response
                decoded_response = Poison.decode!(response_body)
                {:ok, decoded_response, response_headers}  # Return decoded response and headers

            {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
                # Handle other response codes
                {:error, {status_code, response_body}, response_headers}

            {:error, error} ->
                # Handle request error
                {:error, error, response_headers}
        end
    end
end
