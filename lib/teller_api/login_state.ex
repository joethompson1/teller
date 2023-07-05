defmodule TellerApi.LoginState do
	use Agent

	def start_link(initial_state) do
		Agent.start_link(fn -> initial_state end, name: __MODULE__)
	end

	def get_state do
		Agent.get(__MODULE__, & &1)
	end

	def update_state(new_state) do
		Agent.update(__MODULE__, fn _ -> new_state end)
	end
end
