defmodule TellerApi.Account do
	use HTTPoison.Base
	import TellerAPI.Utils.Response

	@base_url "https://test.teller.engineering"
	@account_id "acc_uxbv5e624mbx2ool72xtpbzy7wdl34yohj2away"

	def request_account_balance() do
        # Get the current states
        header_state = TellerApi.State.Header.get_state()

		url = "#{@base_url}/accounts/#{@account_id}/balances"
		headers = header_state

		response = HTTPoison.get(url, headers)
		handle_teller_response(response)
	end
end
