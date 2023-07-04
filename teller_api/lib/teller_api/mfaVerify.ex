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

        f_request_id = response_map["f-request-id"]
        r_token = response_map["r-token"]
        f_token_spec = response_map["f-token-spec"]
        {resultArray, split_character} = decode_f_token_spec(f_token_spec)
        
        {fvar1, fvar2, fvar3} = format_f_token(resultArray, f_request_id, device_id, username, password, api_key)

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
