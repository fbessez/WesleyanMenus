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
		|> decode(response.status_code)
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
defmodule SandC.Menu do
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
###


### Bon Appetit
# http://legacy.cafebonappetit.com/api/2/items?item=4470605
# view-source:http://wesleyan.cafebonappetit.com/cafe/2017-03-27/
# A public API
# http://wesleyan.cafebonappetit.com/wp-json/
# http://wesleyan.cafebonappetit.com/cafe/the-marketplace-at-usdan/2017-03-27/
# http://legacy.cafebonappetit.com/api/2/menus?cafe=332
# Marketplace ID = 332
# Summerfields ID = 337

#  https://github.com/wesleyan
# https://trello.com/b/jCd8aDdO/st-olaf-apis
# https://ist.mit.edu/web-api








