defmodule TellerApi.App do
	import TellerApi.Signin
  	import TellerApi.MFA

  	def start do
  		device_id = IO.gets("Device ID: ") |> to_string() |> String.trim()
	  	res = signin(device_id)  # Pass the deviceId to the signin function
	  	response = elem(res, 1)
      IO.inspect(response)

      header = elem(res, 2)
      IO.inspect(header)

	  	devices = handle_signin_response(response)
	  	# mfa(devices)
	end



  defp handle_signin_response(response) do
    case response do
      %{"result" => "mfa_required", "data" => %{"devices" => devices}} ->
        devices

      _ ->
        # Handle other result values or error cases if needed
        IO.puts("Error: no devices found.")
        []
    end
  end
end
