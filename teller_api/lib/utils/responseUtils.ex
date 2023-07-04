defmodule TellerAPI.Utils.ResponseUtils do

    @moduledoc """
    Utility functions for response messages.
    """

    def get_status_text(status_code) do
        case status_code do
            200 -> "OK"
            400 -> "Bad Request"
            401 -> "Unauthorized"
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
                IO.puts("#{status_code} #{status_text}")
                decoded_body = Poison.decode!(response_body)
                outputResponse(response_headers)
                IO.puts(Poison.encode!(decoded_body, pretty: true) <> "\n")
                {:ok, decoded_body, response_headers}  # Return decoded response and headers

            {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
                # Handle other response codes
                status_text = get_status_text(status_code)
                IO.puts("#{status_code} #{status_text}")
                {:error, {status_code, response_body}, response_headers}

            {:error, error} ->
                # Handle request error
                {:error, error, response_headers}
        end
    end

end
