defmodule TellerAPI.Utils.Response do
    import TellerAPI.Utils.Token

    @moduledoc """
    Utility functions for response messages.
    """

    # returns error text based on error code
    def get_status_text(status_code) do
        case status_code do
            200 -> "OK"
            400 -> "Bad Request"
            401 -> "Unauthorized"
            403 -> "Forbidden"
            404 -> "Not Found"
            _ -> "Unknown"
        end
    end

    # Used to output request and response headers
    def output_response(headers) do
        Enum.each(headers, fn {key, value} ->
            IO.puts("#{key}: #{value}")
        end)
    end

    def handle_response(status_code, body) do
        case status_code do
            200 ->
                # Successful response
                IO.puts(Poison.encode!(body, pretty: true) <> "\n")

            _ ->
                # Unsuccessful response
                status_text = get_status_text(status_code)
                IO.puts("\e[31m#{status_code} #{status_text}\e[0m")
        end
    end

    # Updates the header state based on the response header
    def update_header_state(headers) do
        # Get the current states
        header_state = TellerApi.State.Header.get_state()
        login_state = TellerApi.State.Login.get_state()

        # Finds the f-request-id, f-token-spec, r-token and s-token values within response headers
        {_f_request_id_key, f_request_id} = Enum.find(headers, fn {key, _value} -> key == "f-request-id" end) || {"", ""}
        {_f_token_spec_key, f_token_spec} = Enum.find(headers, fn {key, _value} -> key == "f-token-spec" end) || {"", ""}
        {_r_token_key, r_token} = Enum.find(headers, fn {key, _value} -> key == "r-token" end) || {"", ""}
        {_s_token_key, s_token} = Enum.find(headers, fn {key, _value} -> key == "s-token" end) || {"", ""}

        # Finds the device-id and api-key within state header
        {_device_id_key, device_id} = Enum.find(header_state, fn {key, _value} -> key == "device-id" end) || {"", ""}
        {_api_key_key, api_key} = Enum.find(header_state, fn {key, _value} -> key == "api-key" end) || {"api-key", ""}

        # Creates f-token based on response headers f-token-spec
        {resultArray, split_character} = decode_f_token_spec(f_token_spec)
        {fvar1, fvar2, fvar3} = format_f_token(resultArray, f_request_id, device_id, login_state["username"], login_state["password"], api_key)
        f_token = create_f_token(fvar1, fvar2, fvar3, split_character)

        # Uupdates header with token values
        updated_header_state = Enum.map(header_state, fn {key, value} ->
            case key do
                "r-token" -> {key, r_token}
                "f-token" -> {key, f_token}
                "s-token" -> {key, s_token}
                _ -> {key, value}
            end
        end)

        # saves updated header to state
        TellerApi.State.Header.update_state(updated_header_state)
    end


end
