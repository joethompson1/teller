defmodule TellerApi.Account do
	use HTTPoison.Base
	import TellerAPI.Utils.Response

	@base_url "https://test.teller.engineering"


	def request_account_details(account_id) do
		url = "#{@base_url}/accounts/#{account_id}/details"
        headers = TellerApi.State.Header.get_state()

        {:ok, %HTTPoison.Response{status_code: status_code, body: body, headers: _headers}} = get(url, headers)
        body = Poison.decode!(body)
        handle_response(status_code, body)
	end


	def request_account_balance(account_id) do
		url = "#{@base_url}/accounts/#{account_id}/balances"
        headers = TellerApi.State.Header.get_state()

        {:ok, %HTTPoison.Response{status_code: status_code, body: body, headers: _headers}} = get(url, headers)
        body = Poison.decode!(body)
        handle_response(status_code, body)
	end


	def request_account_transactions(account_id) do
		url = "#{@base_url}/accounts/#{account_id}/transactions"
        headers = TellerApi.State.Header.get_state()

        {:ok, %HTTPoison.Response{status_code: status_code, body: body, headers: _headers}} = get(url, headers)
        body = Poison.decode!(body)
        handle_response(status_code, body)
	end

end
