# yeah

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


IO.inspect Menu.Fetching.finish()



# CHeck out plugins to scrape wordpress
### Star & Crescent
### I could just grab the whole week at once
### Then I don't have to grab specific days
### This is for Star and Crescent
# URL changes all the time
# body = HTTPoison.get!(url, timeout: [10,000]).body
# html_x = Floki.parse(body)
# list_of_entry_content = Floki.find(html_x, ".entry-content")
# raw_html = Floki.raw_html(list_of_entry_content)


### WesWings

# https://weswings.com/category/weswings-specials/feed/
url = "https://weswings.com/category/weswings-specials/"
body = HTTPoison.get!(url).body
html_x = Floki.parse(body)
list = Floki.find(html_x, ".entry-title a")

# def recursive_function(list)
	# curr_tag = hd(list)
	# post_title = hd(elem(curr_tag, 2))  # if it is WesWings Specials...
	# if String.slice(post_title, 0, 13) == "WesWings Spec":
		# curr_val  = elem(curr_tag,1)
		# href_tag  = hd(curr_val)
		# href_val  = elem(href_tag, 1)
		# return href_val
	# else:
		# recursive_function(tl(list))		
			# check for post title on the hd(tl(list))
			# until you get a match
			# if no match return couldn't find it :(
			# if match then return

# content = HTTPoison.get!(href_val).body
# html_x = Floki.parse(content)
# list = Floki.find(html_x, "div .entry-content")
# text = Floki.text(list)
###


### Bon Appetit
# http://legacy.cafebonappetit.com/api/2/items?item=4470605
# view-source:http://wesleyan.cafebonappetit.com/cafe/2017-03-27/
# A public API
# http://wesleyan.cafebonappetit.com/wp-json/
# http://wesleyan.cafebonappetit.com/cafe/the-marketplace-at-usdan/2017-03-27/
#http://legacy.cafebonappetit.com/api/2/menus?cafe=332
#Marketplace ID = 332
# Summerfields ID = 337

#  https://github.com/wesleyan
# https://trello.com/b/jCd8aDdO/st-olaf-apis
# https://ist.mit.edu/web-api








