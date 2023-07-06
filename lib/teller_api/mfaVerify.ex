defmodule TellerApi.MFAVerify do
    use HTTPoison.Base
    import TellerAPI.Utils.Response

    @base_url "https://test.teller.engineering"

    def mfaVerify() do
        url = "#{@base_url}/signin/mfa/verify"
        headers = TellerApi.State.Header.get_state()

        body = %{
            "code" => "123456"
        }

        IO.puts("POST /signin/mfa/verify")
        output_response(headers)
        IO.puts(Poison.encode!(body, pretty: true) <> "\n")

        {:ok, %HTTPoison.Response{status_code: status_code, body: body, headers: headers}} = post(url, Poison.encode!(body), headers)

        body = Poison.decode!(body)
        TellerApi.State.Body.update_state(body)

        if (status_code == 200) do
            status_text = get_status_text(status_code)
            IO.puts("\e[32m#{status_code} #{status_text}\e[0m")
            output_response(headers)
            update_header_state(headers)        
        end

        handle_response(status_code, body)
    end
end


