# mix compile
# iex -S mix
# To compile a thing do elixirc filename
# c("common.ex")
# c("bonAppetit.ex")
# c("menu_fetching")
# c("redAndBlack.ex")
# c("starAndCrescent.ex")
# c("wesWings.ex")

require BonAppetit.Fetch
require Usdan.Menu
require Weswings.Menu
require StarandCrescent.Menu
require RedandBlack.Menu


Usdan.Menu.get_all_necessary_data()
