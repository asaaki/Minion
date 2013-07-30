defmodule Minion.Mixfile do
  use Mix.Project

  def project do
    [ app: :minion,
      version: "0.0.1",
      name: "Minion",
      source_url: "https://github.com/ChaosSteffen/Minion",
      homepage_url: "https://github.com/ChaosSteffen/Minion",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
  [ registered: [:minion],
    mod: { Minion, [] } ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [ { :ex_doc, github: "elixir-lang/ex_doc" },
      { :random, github: "mururu/elixir-random" },
     ]
  end
end
