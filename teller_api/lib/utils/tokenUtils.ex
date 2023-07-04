defmodule TellerAPI.Utils.TokenUtils do
    @moduledoc """
    Utility functions for token operations.
    """

    def decode_f_token_spec(f_token_spec) do
        {:ok, decoded_token} = Base.decode64(f_token_spec)

        # Returns everything inside of brackets
        result =
            case Regex.run(~r/\((.*)\)/, decoded_token) do
                [_, extracted_string] -> extracted_string
                _ -> nil
            end

        # Find the character to do the split on
        split_character =
            case result do
                "--" -> "--"
                _ -> String.graphemes(result) |> Enum.find(&(&1 =~ ~r/[^A-Za-z0-9-]/ and &1 != "-")) || "--"
            end

        # Split the string on the split_character
        resultArray = String.split(result, ~r/#{Regex.escape(split_character)}/)

        # if split character is "::" then resultArray will be length 5 due to empty spaces
        if length(resultArray) == 5 do
            modifiedArray = [
                Enum.at(resultArray, 0),
                Enum.at(resultArray, 2),
                Enum.at(resultArray, 4)
            ]
            {modifiedArray, "::"}        
        else
            {resultArray, split_character}
        end
    end


    def format_f_token(resultArray, f_request_id, device_id, username, password, api_key) do
        [result1, result2, result3] = resultArray

        variable_map = %{
            "last-request-id" => f_request_id,
            "username" => username,
            "password" => password,
            "device-id" => device_id,
            "api-key" => api_key,
        }

        fvar1 = variable_map[result1]
        fvar2 = variable_map[result2]
        fvar3 = variable_map[result3]

        {fvar1, fvar2, fvar3}
    end


    def create_f_token(var1, var2, var3, split_character) do
        concatenated_string = "#{var1}#{split_character}#{var2}#{split_character}#{var3}"
        hash = :crypto.hash(:sha256, concatenated_string)
        f_token = Base.encode64(hash, padding: false)

        f_token
    end
end
