defmodule TellerApi.AccountDetails do
	use HTTPoison.Base

	@base_url "https://test.teller.engineering"
	@account_id "acc_uxbv5e624mbx2ool72xtpbzy7wdl34yohj2away"

	def request_account_details(access_token) do
		url = "#{@base_url}/accounts/#{@account_id}/details"
		headers = [
			{"Authorization", "Bearer #{access_token}"}
		]

		case HTTPoison.get(url, headers) do
			{:ok, %{status_code: 200, body: body}} ->
				account_details = Jason.decode!(body)
				account_id = Map.get(account_details, "account_id")
				account_number = Map.get(account_details, "account_number")
				links = Map.get(account_details, "links")
				routing_numbers = Map.get(account_details, "routing_numbers")
				# Process the extracted information as needed
				IO.puts("Account ID: #{account_id}")
				IO.puts("Account Number: #{account_number}")
				IO.inspect(links)
				IO.inspect(routing_numbers)

			{:ok, %{status_code: 400, body: body}} ->
				error_details = Jason.decode!(body)
				error_message = Map.get(error_details, "error") |> Map.get("message")
				IO.puts("Request failed with error (#{400}): #{error_message}")

			{:error, %{reason: reason}} ->
				IO.puts("Request failed with reason: #{reason}")
		end
	end
end
