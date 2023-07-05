defmodule TellerApi.MFAVerify do
    use HTTPoison.Base
    import TellerAPI.Utils.ResponseUtils

    @base_url "https://test.teller.engineering"

    def mfaVerify() do
        # Get the current states
        header_state = TellerApi.HeaderState.get_state()

        url = "#{@base_url}/signin/mfa/verify"
        headers = header_state

        body = %{
            "code" => "123456"
        }

        IO.puts("POST /signin/mfa/verify")
        output_response(headers)
        IO.puts(Poison.encode!(body, pretty: true) <> "\n")


        response = post(url, Poison.encode!(body), headers)
        {:ok, unpacked} = response
        response_headers = unpacked.headers


        handle_response(response, response_headers)
    end
end


