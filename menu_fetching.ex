# mix run menu_fetching.ex

defmodule Menu.Fetching do
	def fetch() do
		url = "http://wesleyan.cafebonappetit.com/cafe/summerfields/"
		# Define a function get_url/1 that takes what you want to do 
			# like, dislike, message. and so on
			# which basically case type of o
		{:ok, response} = HTTPoison.get(url, [timeout: 10_000])
		response
	end

	def decode(body, status_code) do
		case status_code do
			200 ->
				body = Poison.decode!(body)
				body
			_ -> 
				"Sorry"
		end
	end

	def get_body(response) do
		Map.from_struct(response)
		|> Map.fetch!(:body)
		# |> decode(response.status_code)
	end

	def finish() do
		fetch()
		|> get_body
		|> decode(200)
	end
end


# CHeck out plugins to scrape wordpress
### Star & Crescent
### I could just grab the whole week at once
### Then I don't have to grab specific days
### This is for Star and Crescent
# URL changes all the time
defmodule StarandCrescent.Menu do
	# Need to either scrape for the correct link or just guess it...
	def get_body do
		url = "http://wesleying.org/2017/03/05/star-and-crescent-menu-week-of-36/"
		HTTPoison.get!(url).body
		|> Floki.parse
		|> Floki.find(".entry-content")
		|> Floki.raw_html
	end
end

# IO.inspect SandC.Menu.get_body

# case HTTPoison.get(url) do
#   {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
#     IO.puts body
#   {:ok, %HTTPoison.Response{status_code: 404}} ->
#     IO.puts "Not found :("
#   {:error, %HTTPoison.Error{reason: reason}} ->
#     IO.inspect reason
# end

### WesWings
# This just gets the most recently posted. not necessarily TODAYs

defmodule Weswings.Menu do

	def get_body() do
		url = "https://weswings.com/category/weswings-specials/"
		HTTPoison.get!(url).body
		|> Floki.parse
		|> Floki.find(".entry-title a")
		|> find_correct_post
		|> scrape_menu_items
	end

	def find_correct_post(found_floki) when length(found_floki) == 0, do: false
	def find_correct_post(found_floki) do
		curr_tag = hd(found_floki)
		post_title = hd(elem(curr_tag, 2))
		case String.slice(post_title, 0, 13) do
			"WesWings Spec" -> 
				curr_tag
				|> elem(1)
				|> hd()
				|> elem(1)
			_ -> find_correct_post(tl(found_floki))
		end
	end

	def scrape_menu_items(false), do: "Sorry, check out \'https://weswings.com/category/weswings-specials/\' for today's specials"
	def scrape_menu_items(url) do
		case url do
			false -> "Sorry, check out #{url} for today's specials"
			_ -> 
				IO.inspect url
				HTTPoison.get!(url).body
				|> Floki.parse()
				|> Floki.find("div .entry-content")
				|> Floki.text
		end
	end
end

# IO.inspect Weswings.Menu.get_body()


defmodule BonAppetit.Menu do
	cafe = "332"
	url = 'http://legacy.cafebonappetit.com/api/2/menus?cafe=#{cafe}'

	def fetch(url) do
		{:ok, response} = HTTPoison.get(url, [])
		get_body(response)
	end

	def get_body(response) do
		response
		|> Map.from_struct
		|> Map.fetch!(:body)
		|> decode_body(response.status_code)
	end

	def decode_body(body, status_code) do
		case status_code do
			200 -> 
				Poison.decode!(body)
				# for {key, val} <- z, into: %{}, do: {String.to_atom(key), val} 
			_ ->
				"No!"
		end
	end


	def fetch2(url) do
		{:ok, response} = HTTPoison.get(url, [])
		secondary(response)
	end

	def secondary(response) do
	    response
	    |> Map.from_struct
	    |> Map.fetch!(:body)
	    |> decode_body
	end

	def decode_body(body) do
		{:ok, body_map} = Poison.decode(body)
		finish(body_map)
	end

	def finish(body_map) do
		IO.inspect body_map
	end

	def get_item_label(body_map, item_no) do
		item_label = body_map["items"][item_no]["label"]
	end

	def get_breakfast_items(body_map) do
		breakfast = hd(hd(hd body_map["days"])["cafes"][cafe]["dayparts"]))
		# which meal is it? breakfast, lunch, dinner, brunch?
		meal = breakfast["label"]
		# a list of stations and what's being served
		stations = breakfast["stations"]

	end

end

BonAppetit.Menu.fetch2('http://legacy.cafebonappetit.com/api/2/menus?cafe=332')

### Bon Appetit

# view-source:http://wesleyan.cafebonappetit.com/cafe/2017-03-27/


### A public API explanation
# http://wesleyan.cafebonappetit.com/wp-json/

#### THESE ONLY DISPLAY ITEM NUMBERS
## DAILY JSON FOR MENU ITEMS AT USDAN
# http://legacy.cafebonappetit.com/api/2/menus?cafe=332
# Marketplace ID = 332

## DAILY JSON FOR MENU ITEMS AT Summies
# http://legacy.cafebonappetit.com/api/2/menus?cafe=337
# Summerfields ID = 337

## Item Query Lookup URL
# http://legacy.cafebonappetit.com/api/2/items?item=4470605

#  https://github.com/wesleyan
# https://trello.com/b/jCd8aDdO/st-olaf-apis
# https://ist.mit.edu/web-api








