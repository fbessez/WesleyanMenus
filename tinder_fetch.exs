anonymous_function = fn a, b -> a + b end

IO.puts anonymous_function.(1,2)


# IO.puts Poison.Parser.parse!(~s({"name": "Devin Torres", "age": 27}))
IO.puts Poison.Encoder.encode([1, 2, 3], [])


# HTTPoison.start
# {:ok, response} = HTTPoison.get("http://httparrot.herokuapp.com/get")
# IO.inspect response

defmodule Tinder.Fetching do
	def fetch() do
		url = "http://httparrot.herokuapp.com/get"
		# Define a function get_url/1 that takes what you want to do 
			# like, dislike, message. and so on
			# which basically case type of o
		{:ok, response} = HTTPoison.get(url, [timeout: 10_000])
		response
	end

	def decode(body, status_code) do
		case status_code do
			200 ->
				IO.inspect Poison.decode!(body)
			_ -> 
				"Sorry"
		end
	end

	def get_body(response) do
		response
		|> Map.from_struct
		|> Map.fetch!(:body)
		# |> decode(response.status_code)
	end

	def finish() do
		fetch()
		|> get_body
		|> decode(200)
	end
end



# XML and XPATH






