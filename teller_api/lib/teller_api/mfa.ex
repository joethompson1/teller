defmodule TellerApi.MFA do
  use HTTPoison.Base

  @base_url "https://test.teller.engineering"

  def mfa([]) do
    IO.puts("Error: no devices found.")
  end



  def mfa([device | _rest]) do
    device_id = device["id"]

    url = "#{@base_url}/signin/mfa"
    headers = [
      {"teller-mission", "https://blog.teller.io/2021/06/21/our-mission.html"},
      {"User-Agent", "Teller Bank iOS 2.0"},
      {"api-key", "HowManyGenServersDoesItTakeToCrackTheBank?"},
      {"device-id", "AQ5JMTAJ4YGFQBHG"},
      {"r-token", "QTEyOEdDTQ.a39xYIUiXQ6qpj1ohGWHEzXrkhKQ0K0dAAJdB84S4gmvt_Uw0H9ErvHwoJQ.t2OncUfunpoOCgzv.LXzZoY0LnO56klo71UvOJ4an0hrtp2w-doPf6fk1F3QLcbqDZuiMtSkPXCQWbmCirqqDHnt4J5aQdenfEYU1p7Tn5bA1UccXjHZT0q64mnLnAel3JXNe3Zcng8FUJUfgA2EG4A2qGMsUXx3jfZp7xCpbG-dsnMY_VYYbgKw7qY5Ud7JCY1Q54Pb7vgxuJQrRFM6y8D9giOTh90Cq8yxs13GwGzUQ2mUpd-pd.m8vSdhNndqfK9mWPaIy37A"},
      {"f-token", "M+ADtlOSpwZs1b5f+9/WXU4IhEitZPl0hwARYPtpG2Y"},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]
    body = %{
      "device_id" => device_id
    }

    response = post(url, Poison.encode!(body), headers)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        # Handle successful MFA response
        decoded_response = Poison.decode!(response_body)
        IO.inspect(decoded_response, pretty: true)

      {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
        # Handle other response codes
        IO.inspect({status_code, response_body})

      {:error, error} ->
        # Handle request error
        IO.inspect(error)
    end
  end
end
