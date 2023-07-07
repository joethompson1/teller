defmodule TellerApi.Signin do
    use HTTPoison.Base
    import TellerAPI.Utils.Response

    @base_url "https://test.teller.engineering"

    def signin(header_state, body_state) do
        
        url = "#{@base_url}/signin"
        headers = header_state
        body = %{
            "username" => body_state["username"],
            "password" => body_state["password"],
        }

        # Outputs request headers and body
        IO.puts("POST /signin")
        output_response(headers)
        IO.puts(Poison.encode!(body, pretty: true) <> "\n")

        # Makes post request and handles response
        {:ok, %HTTPoison.Response{status_code: status_code, body: body, headers: headers}} = post(url, Poison.encode!(body), headers)

        # Decodes response body and updates body state
        body = Poison.decode!(body)
        TellerApi.State.Body.update_state(body)

        # Outputs response headers and updates header state
        if (status_code == 200) do
            status_text = get_status_text(status_code)
            IO.puts("\e[32m#{status_code} #{status_text}\e[0m")
            output_response(headers)
            update_header_state(headers)        
        end

        handle_response(status_code, body)
    end
end
