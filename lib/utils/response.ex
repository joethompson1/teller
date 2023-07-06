defmodule TellerAPI.Utils.Response do
    import TellerAPI.Utils.Token

    @moduledoc """
    Utility functions for response messages.
    """

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


    def output_response(headers) do
        Enum.each(headers, fn {key, value} ->
            IO.puts("#{key}: #{value}")
        end)
    end


    def update_header_state(headers) do
        # Get the current states
        header_state = TellerApi.State.Header.get_state()
        login_state = TellerApi.State.Login.get_state()

        {_device_id_key, device_id} = Enum.find(header_state, fn {key, _value} -> key == "device-id" end) || {"", ""}
        {_api_key_key, api_key} = Enum.find(header_state, fn {key, _value} -> key == "api-key" end) || {"", ""}
        {_f_request_id_key, f_request_id} = Enum.find(headers, fn {key, _value} -> key == "f-request-id" end) || {"", ""}
        {_f_token_spec_key, f_token_spec} = Enum.find(headers, fn {key, _value} -> key == "f-token-spec" end) || {"", ""}
        {_r_token_key, r_token} = Enum.find(headers, fn {key, _value} -> key == "r-token" end) || {"", ""}
        {_s_token_key, s_token} = Enum.find(headers, fn {key, _value} -> key == "s-token" end) || {"", ""}


        {resultArray, split_character} = decode_f_token_spec(f_token_spec)
        {fvar1, fvar2, fvar3} = format_f_token(resultArray, f_request_id, device_id, login_state["username"], login_state["password"], api_key)
        f_token = create_f_token(fvar1, fvar2, fvar3, split_character)

        updated_header_state = Enum.map(header_state, fn {key, value} ->
            case key do
                "r-token" -> {key, r_token}
                "f-token" -> {key, f_token}
                "s-token" -> {key, s_token}
                _ -> {key, value}
            end
        end)

        TellerApi.State.Header.update_state(updated_header_state)
    end


    def handle_response(response, response_headers) do
        case response do
            {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
                # Successful response
                status_code = 200
                status_text = get_status_text(status_code)
                IO.puts("\e[32m#{status_code} #{status_text}\e[0m")
                decoded_body = Poison.decode!(response_body)
                output_response(response_headers)
                update_header_state(response_headers)
                IO.puts(Poison.encode!(decoded_body, pretty: true) <> "\n")

            {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
                error_details = Poison.decode!(response_body)
                status_text = get_status_text(status_code)
                error_message = Map.get(error_details, "error") |> Map.get("message")
                IO.puts("\e[31m#{status_code} #{status_text}\e[0m")
                IO.puts("#{error_message}")

            {:error, error} ->
                IO.puts("Request failed: #{error}")
        end
    end


    def handle_teller_response(response) do
        case response do
            {:ok, %{status_code: 200, body: body}} ->
                status_code = 200
                status_text = get_status_text(status_code)
                IO.puts("\e[32m#{status_code} #{status_text}\e[0m")
                account_details = Poison.decode!(body)
                IO.puts(Poison.encode!(account_details, pretty: true) <> "\n")

            {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
                error_details = Poison.decode!(body)
                status_text = get_status_text(status_code)
                error_message = Map.get(error_details, "error") |> Map.get("message")
                IO.puts("\e[31m#{status_code} #{status_text}\e[0m")
                IO.puts("#{error_message}")

            {:error, %{reason: reason}} ->
                IO.puts("Request failed: #{reason}")
        end
    end

end
