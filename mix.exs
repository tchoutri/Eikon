defmodule Eikon.Mixfile do
  use Mix.Project

  def project do
    [app: :eikon,
     description: "Eikōn is an Elixir library providing a read-only interface for image files.",
     version: "0.0.1",
     elixir: "~> 1.2",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
     
  end

  def application, do: []

  defp deps do
    [
      {:ex_doc, "~> 0.11", only: :dev},
      {:earmark, "~> 0.2", only: :dev}
    ]
  end

  defp package do
    [
      files:       ["lib", "README.md", "mix.exs"],
      maintainers: ["Théophile Choutri <theophile@choutri.eu>"], 
      licenses:    ["MIT"],
      links:       %{"Github" => "https://github.com/tchoutri/eikon", "Documentation" => "https://hexdocs.pm/eikon"}
    ]
  end
end
