defmodule TellerApi.Account do
	use HTTPoison.Base
	import TellerAPI.Utils.Response

	@base_url "https://test.teller.engineering"
	@account_id "acc_uxbv5e624mbx2ool72xtpbzy7wdl34yohj2away"

	def request_account_balance() do
		url = "#{@base_url}/accounts/#{@account_id}/balances"
        headers = TellerApi.State.Header.get_state()

        {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = get(url, headers)
        body = Poison.decode!(body)
        handle_response(status_code, body)
	end
end
