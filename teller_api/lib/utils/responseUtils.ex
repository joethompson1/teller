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

end
