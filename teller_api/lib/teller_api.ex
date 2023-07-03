defmodule TellerApi do
  use HTTPoison.Base

  @base_url "https://test.teller.engineering"  # Replace with your API endpoint

  def make_post_request do
    url = "#{@base_url}/signin"
    headers = [
      {"User-Agent", "Teller Bank iOS 2.0"},
      {"api-key", "HowManyGenServersDoesItTakeToCrackTheBank?"},
      {"device-id", "FUDMHJCIVHPXVV2R"},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]
    body = %{
      "password" => "papuanewguinea",
      "username" => "green_lucky"
    }

    response = post(url, Poison.encode!(body), headers)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        # Successful response
        decoded_response = Poison.decode!(response_body)
        decoded_response

      {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
        # Handle other response codes
        {status_code, response_body}

      {:error, error} ->
        # Handle request error
        error
    end
  end
end
