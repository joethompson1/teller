defmodule TellerApi.MFA do
    use HTTPoison.Base
    import TellerAPI.Utils.TokenUtils

    @base_url "https://test.teller.engineering"

    def mfa([], _header) do
        IO.puts("Error: no devices found.")
    end

    def mfa([device | _rest], header) do
        device_id = Application.get_env(:teller_api, :device_id)
        username = Application.get_env(:teller_api, :username)
        password = Application.get_env(:teller_api, :password)
        api_key = Application.get_env(:teller_api, :api_key)

        mfa_device_id = device["id"]

        header_map = Enum.into(header, %{})

        f_request_id = Map.get(header_map, "f-request-id", nil)
        r_token = Map.get(header_map, "r-token", nil)
        f_token_spec = Map.get(header_map, "f-token-spec", nil)
        {resultArray, split_character} = decode_f_token_spec(f_token_spec)
        [result1, result2, result3] = resultArray

        variable_map = %{
            "last-request-id" => f_request_id,
            "username" => username,
            "password" => password,
            "device-id" => device_id,
            "api-key" => api_key,
        }

        fvar1 = variable_map[result1]
        fvar2 = variable_map[result2]
        fvar3 = variable_map[result3]

        f_token = create_f_token(fvar1, fvar2, fvar3, split_character)

        url = "#{@base_url}/signin/mfa"
        headers = [
            {"teller-mission", "accepted!"},
            {"user-agent", "Teller Bank iOS 2.0"},
            {"api-key", api_key},
            {"device-id", device_id},
            {"r-token", r_token},
            {"f-token", f_token},
            {"content-type", "application/json"},
            {"accept", "application/json"}
        ]

        body = %{
            "device_id" => mfa_device_id
        }

        response = post(url, Poison.encode!(body), headers)
        {:ok, unpacked} = response
        response_headers = unpacked.headers
        IO.inspect(response_headers)

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
