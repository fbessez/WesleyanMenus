require Common


defmodule RedandBlack.Menu do

	# Grabs the latest post on Red-black specials website
	def get_post_url do
		Common.get_body("https://weswings.com/category/red-black-specials/")
		|> hd()
		|> Floki.attribute("href")
		|> hd()
		|> scrape_menu_items()
	end

	def scrape_menu_items(url) do
		case url do
			false -> "Sorry, check out #{url} for today's specials"
			_ ->
				IO.inspect url
				HTTPoison.get!(url).body
				|> Floki.parse()
				|> Floki.find("div .entry-content")
			 	|> Floki.filter_out("div div") #leaves you with just the items
			 	|> Floki.raw_html #leaves you with some good html!!
			 	|> Common.remove_newline
		end
	end
end
