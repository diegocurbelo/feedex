defmodule Feedex.Mixfile do
  use Mix.Project

  def project do
    [app: :feedex,
     version: "0.1.2",
     elixir: "~> 1.4",
     description: "Elixir Feed Parser",
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev},
     {:html_sanitize_ex, "~> 1.3"},
     {:httpoison, "~> 0.13"},
     {:sweet_xml, "~> 0.6.5"},
     {:timex, "~> 3.1"}]
  end

  def package do
    [ maintainers: ["diegocurbelo"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/diegocurbelo/feedex"}]
  end
end
