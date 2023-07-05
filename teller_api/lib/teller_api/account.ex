defmodule TellerApi.Account do
	use HTTPoison.Base
	import TellerAPI.Utils.TokenUtils
	import TellerAPI.Utils.ResponseUtils

	@base_url "https://test.teller.engineering"
	@account_id "acc_uxbv5e624mbx2ool72xtpbzy7wdl34yohj2away"

	def request_account_balance(prevResponse) do
		device_id = Application.get_env(:teller_api, :device_id)
        username = Application.get_env(:teller_api, :username)
        password = Application.get_env(:teller_api, :password)
        api_key = Application.get_env(:teller_api, :api_key)

        response_map = Enum.into(prevResponse, %{})
        IO.inspect(response_map)

        f_request_id = response_map["f-request-id"]
        r_token = response_map["r-token"]
        f_token_spec = response_map["f-token-spec"]
        s_token = response_map["s-token"]
        {resultArray, split_character} = decode_f_token_spec(f_token_spec)
        
        {fvar1, fvar2, fvar3} = format_f_token(resultArray, f_request_id, device_id, username, password, api_key)

        f_token = create_f_token(fvar1, fvar2, fvar3, split_character)

		url = "#{@base_url}/accounts/#{@account_id}/balances"
		headers = [
			{"teller-mission", "accepted!"},
            {"user-agent", "Teller Bank iOS 2.0"},
            {"api-key", api_key},
            {"device-id", device_id},
            {"r-token", r_token},
            {"f-token", f_token},
            {"s-token", s_token},
            {"content-type", "application/json"},
            {"accept", "application/json"}
		]

		response = HTTPoison.get(url, headers)
		handle_teller_response(response)
	end
end
