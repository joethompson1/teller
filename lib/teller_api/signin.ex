defmodule TellerApi.Signin do
    use HTTPoison.Base
    import TellerAPI.Utils.ResponseUtils

    @base_url "https://test.teller.engineering"

    def signin() do
        # Get the current states
        header_state = TellerApi.HeaderState.get_state()
        body_state = TellerApi.LoginState.get_state()

        url = "#{@base_url}/signin"
        headers = header_state
        body = %{
            "username" => body_state["username"],
            "password" => body_state["password"],
        }

        IO.puts("POST /signin")
        output_response(headers)
        IO.puts(Poison.encode!(body, pretty: true) <> "\n")


        response = post(url, Poison.encode!(body), headers)
        {:ok, unpacked} = response
        response_headers = unpacked.headers
        response_body = Poison.decode!(unpacked.body)
        TellerApi.BodyState.update_state(response_body)
        
        handle_response(response, response_headers)
    end
end
