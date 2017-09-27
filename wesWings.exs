require Common


### WesWings --> COMPLETE-ish
# This just gets the most recently posted. not necessarily TODAYs
defmodule Weswings.Menu do

	def get_body() do
		Common.get_body("https://weswings.com/category/weswings-specials/")
		|> find_correct_post
		|> scrape_menu_items
	end

	def date_string do
		local_time = :calendar.local_time()
		month = to_string(elem(elem(local_time, 0), 1))
		day = to_string(elem(elem(local_time, 0), 2))
		month <> "-" <> day
	end

	def find_correct_post(found_floki) when length(found_floki) == 0, do: false
	def find_correct_post(found_floki) do
		curr_tag = hd(found_floki)
		post_title = hd(elem(curr_tag, 2))
		case (post_title =~ date_string()) do
			true ->
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
			 	|> Floki.filter_out("div div") #leaves you with just the items
			 	|> Floki.raw_html #leaves you with some good html!!
			 	|> Common.remove_newline
			 	|> IO.inspect
		end
	end
end
