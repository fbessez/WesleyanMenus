# mix run menu_fetching.ex

defmodule Common do
	def get_body(url) do
		HTTPoison.get!(url).body
		|> Floki.parse
		|> Floki.find(".entry-title a")
		|> Floki.filter_out("i")
	end

	def remove_newline(string) do
		Regex.replace(~r/\n/, string, "")
	end
end
