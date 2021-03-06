defmodule WesleyanMenus.Mixfile do
  use Mix.Project

  def application do
    [applications: [:poison, :httpotion, :httpoison, :floki]]
  end

  def project do
    [app: :WesleyanMenus,
     version: "1.0.0",
     deps: deps()]
  end

  defp deps do
     [
     {:poison, "~> 3.1.0"},
     {:httpotion, "~> 3.0.2"},
     {:httpoison, "~> 0.10.0"},
     {:floki, "~> 0.14.0"}
     ]
  end
end