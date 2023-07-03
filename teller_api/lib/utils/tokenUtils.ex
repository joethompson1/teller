defmodule TellerAPI.Utils.TokenUtils do
    @moduledoc """
    Utility functions for token operations.
    """

    def decode_f_token_spec(f_token_spec) do
        {:ok, decoded_token} = Base.decode64(f_token_spec)

        result =
            case Regex.run(~r/\((.*)\)/, decoded_token) do
                [_, extracted_string] -> extracted_string
                _ -> nil
            end

        split_character =
            case result do
                "--" -> "--"
                _ -> String.graphemes(result) |> Enum.find(&(&1 =~ ~r/[^A-Za-z0-9-]/ and &1 != "-")) || "--"
            end

        resultArray = String.split(result, ~r/#{Regex.escape(split_character)}/)
        {resultArray, split_character}
    end

    def create_f_token(var1, var2, var3, split_character) do
        concatenated_string = "#{var1}#{split_character}#{var2}#{split_character}#{var3}"
        hash = :crypto.hash(:sha256, concatenated_string)
        f_token = Base.encode64(hash, padding: false)

        f_token
    end
end
