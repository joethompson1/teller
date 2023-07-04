defmodule TellerApi.MFAVerify do
    use HTTPoison.Base
    import TellerAPI.Utils.TokenUtils
    import TellerAPI.Utils.ResponseUtils

    @base_url "https://test.teller.engineering"

    def mfaVerify(prevResponse) do
        device_id = Application.get_env(:teller_api, :device_id)
        username = Application.get_env(:teller_api, :username)
        password = Application.get_env(:teller_api, :password)
        api_key = Application.get_env(:teller_api, :api_key)

        response_map = Enum.into(prevResponse, %{})

        f_request_id = Map.get(response_map, "f-request-id", nil)
        r_token = Map.get(response_map, "r-token", nil)
        f_token_spec = Map.get(response_map, "f-token-spec", nil)
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

        url = "#{@base_url}/signin/mfa/verify"
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
            "code" => "123456"
        }


        IO.puts("POST /signin/mfa/verify")
        outputResponse(headers)
        IO.puts(Poison.encode!(body, pretty: true) <> "\n")


        response = post(url, Poison.encode!(body), headers)
        {:ok, unpacked} = response
        response_headers = unpacked.headers


        handle_response(response, response_headers)
    end
end
