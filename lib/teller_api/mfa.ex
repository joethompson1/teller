defmodule TellerApi.MFA do
    use HTTPoison.Base
    import TellerAPI.Utils.Response

    @base_url "https://test.teller.engineering"

    def mfa() do
        # Gets the mfa device id from body state
        body_state = TellerApi.State.Body.get_state()
        devices = body_state["data"]["devices"]
        first_device = List.first(devices)
        mfa_device_id = Map.get(first_device, "id", "")

        url = "#{@base_url}/signin/mfa"
        headers = TellerApi.State.Header.get_state()

        body = %{
            "device_id" => mfa_device_id 
        }

        # Outputs request headers and body
        IO.puts("POST /signin/mfa")
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
