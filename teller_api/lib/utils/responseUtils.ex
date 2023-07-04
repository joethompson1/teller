defmodule TellerAPI.Utils.ResponseUtils do

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


    def outputResponse(headers) do
        Enum.each(headers, fn {key, value} ->
            IO.puts("#{key}: #{value}")
        end)
    end


    def handle_response(response, response_headers) do
        case response do
            {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
                # Successful response
                status_code = 200
                status_text = get_status_text(status_code)
                IO.puts("\e[32m#{status_code} #{status_text}\e[0m")
                decoded_body = Poison.decode!(response_body)
                outputResponse(response_headers)
                IO.puts(Poison.encode!(decoded_body, pretty: true) <> "\n")
                {:ok, decoded_body, response_headers}  # Return decoded response and headers

            {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
                error_details = Poison.decode!(response_body)
                status_text = get_status_text(status_code)
                error_message = Map.get(error_details, "error") |> Map.get("message")
                IO.puts("\e[31m#{status_code} #{status_text}\e[0m")
                IO.puts("#{error_message}")
                {:error, {status_code, response_body}, response_headers}

            {:error, error} ->
                IO.puts("Request failed: #{error}")
                {:error, error, response_headers}
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
