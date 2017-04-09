# mix run menu_fetching.ex

defmodule Common do
	def get_body(url) do
		HTTPoison.get!(url).body
		|> Floki.parse
		|> Floki.find(".entry-title a")
		|> Floki.filter_out("i")
	end
end


### Star & Crescent
### I could just grab the whole week at once
defmodule StarandCrescent.Menu do
	def get_body do
		url = "http://wesleying.org/author/star-and-crescent/"
		Common.get_body(url)
		|> find_correct_post
		|> scrape_menu_items
		# |> Floki.find(".entry-content")
		# |> Floki.raw_html
	end

	def find_correct_post(found_floki) when length(found_floki) == 0, do: false
	def find_correct_post(found_floki) do
		case (hd found_floki) do
			{"a", [{"href", ""}], [{"i", [{"class", ""}], []}]} -> find_correct_post((tl found_floki))
			{"a", [{"href", ""}], []} -> find_correct_post((tl found_floki))
			_ -> 
				curr = hd found_floki
				title = hd(elem(curr, 2))
				case String.slice(title, 0, 22) do
		# case title = "Star and Crescent Menu"
		# this should be grabbing top down so most recent
		# otherwise i can match with the current week 4/4 or 3/27 or whatever
					"Star and Crescent Menu" -> 
						Floki.attribute(curr, "href")
						|> hd()
					_ -> find_correct_post(tl found_floki)
				end
		end
	end

	def scrape_menu_items(false), do: "Sorry couldn't find the menu. Check out \"http://wesleying.org/author/star-and-crescent/\""
	def scrape_menu_items(url) do
		IO.puts url
		# IO.puts "Not Yet Implemented"
		{:ok, res} = HTTPoison.get(url, [])
		res.body
		|> Floki.parse()
		|> Floki.find("div, .entry-content")
		|> Floki.filter_out("div p img")
		|> Floki.raw_html
	end
end

# IO.inspect StarandCrescent.Menu.get_body()


### WesWings --> COMPLETE-ish
# This just gets the most recently posted. not necessarily TODAYs
defmodule Weswings.Menu do

	def get_body() do
		Common.get_body("https://weswings.com/category/weswings-specials/")
		|> find_correct_post
		|> scrape_menu_items
	end

	def find_correct_post(found_floki) when length(found_floki) == 0, do: false
	def find_correct_post(found_floki) do
		curr_tag = hd(found_floki)
		post_title = hd(elem(curr_tag, 2))
		case String.slice(post_title, 0, 13) do
			# Or i could case on if 4-9-17 is in the title
			"WesWings Spec" -> 
				curr_tag
				|> Floki.attribute("href")
				|> hd()
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
			# Floki.find("b") lists all the specials of the day
			# Floki.find("h3") lists the meals
			 	|> Floki.filter_out("div div") #leaves you with just the items
			 	|> Floki.raw_html #leaves you with some good html!!
			# |> Floki.text
		end
	end
end

# IO.inspect Weswings.Menu.get_body()



defmodule BonAppetit.Fetch do
	@usdan "332"
	@summies "337"
	@usdanurl "http://legacy.cafebonappetit.com/api/2/menus?cafe=#{@usdan}"
	@summiesurl "http://legacy.cafebonappetit.com/api/2/menus?cafe=#{@summies}"

	def fetch_usdan() do
		{:ok, response} = HTTPoison.get(@usdanurl, [])
		secondary(response)
	end

	def fetch_summies() do 
		{:ok, response} = HTTPoison.get(@summiesurl, [])
		secondary(response)
	end

	def secondary(response) do
	    response
	    |> Map.from_struct
	    |> Map.fetch!(:body)
	    |> Poison.decode!
	end
end

defmodule Usdan.Menu do
	@usdan "332"
	@summies "337"
	@body_map BonAppetit.Fetch.fetch_usdan()

	def get_body_map, do: @body_map
	def get_items_index, do: @body_map["items"]

	def get_all_necessary_data() do
		menu = hd (hd get_body_map["days"])["cafes"][@usdan]["dayparts"]
		IO.inspect dayparts(menu, %{})
	end

	#  hd (hd body_map["days"])["cafes"][cafe]["dayparts"] 
	def dayparts(dayparts, map) when length(dayparts) <= 0, do: map
	def dayparts(dayparts, map) do
		curr_daypart = hd dayparts
		daypart_label = curr_daypart["label"]
		daypart_stations = curr_daypart["stations"]
		map = Map.put(map, daypart_label, stations(daypart_stations, %{}))
		dayparts((tl dayparts), map)
	end

	# (hd (hd (hd body_map["days"])["cafes"][cafe]["dayparts"])) ["stations"]
	def stations(stations, map) when length(stations) <= 0, do: map
	def stations(stations, map) do
		curr_station = hd stations
		station = curr_station["label"]
		station_items = get_item_names((curr_station["items"]), [])
		map = Map.put(map, station, station_items)
		stations((tl stations), map)
	end


	def get_item_names(item_list, item_names) when length(item_list) <= 0, do: item_names
	def get_item_names(item_list, item_names) do
		curr_item_no = hd item_list
		item_name = get_item_name(curr_item_no)
		item_names = item_names ++ [item_name]
		get_item_names((tl item_list),item_names)
	end

	def get_item_name(item_no) do
		get_items_index[item_no]["label"]
	end


# Need to somehow store all item numbers and descriptions in config?
# by calling the api?
end

Usdan.Menu.get_all_necessary_data()





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








