defmodule TellerApi.MFA do
    use HTTPoison.Base
    import TellerAPI.Utils.ResponseUtils

    @base_url "https://test.teller.engineering"

    def mfa() do
        # Get the current states
        header_state = TellerApi.HeaderState.get_state()
        body_state = TellerApi.BodyState.get_state()

        devices = body_state["data"]["devices"]
        first_device = List.first(devices)
        mfa_device_id = Map.get(first_device, "id", "")

        url = "#{@base_url}/signin/mfa"
        headers = header_state

        body = %{
            "device_id" => mfa_device_id 
        }

        IO.puts("POST /signin/mfa")
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
