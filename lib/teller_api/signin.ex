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

        IO.puts("POST /signin")
        output_response(headers)
        IO.puts(Poison.encode!(body, pretty: true) <> "\n")

        {:ok, %HTTPoison.Response{status_code: status_code, body: body, headers: headers}} = post(url, Poison.encode!(body), headers)

        body = Poison.decode!(body)
        TellerApi.State.Body.update_state(body)

        update_header_state(headers)

        status_text = get_status_text(status_code)
        IO.puts("\e[32m#{status_code} #{status_text}\e[0m")
        output_response(headers)

        handle_response(status_code, body)
    end
end
