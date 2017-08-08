defmodule Feedex do
  @moduledoc """
  A simple elixir feed parser.
  """
  require Logger

  alias Feedex.Helpers.{Fetch, Xml, Sanitizer}
  alias Feedex.Parsers.{Atom, RSS1, RSS2}


  def fetch_and_parse(url) do
    try do
      with {:ok, xml} <- Fetch.get(url) do
        parse(xml)
      end
    rescue
      e -> {:error, :unknown, e}
    end
  end


  def parse(xml) do
    with {:ok, content} <- Xml.preprocess(xml),
         {:ok, parser}  <- select_parser(content),
         {:ok, feed}    <- parser.parse(content) do

      base_url = extract_base_url(feed.url)

      entries =
        feed.entries
        |> Enum.filter(fn(e) -> e.title != nil && e.content != nil end)
        |> Enum.sort(&(DateTime.compare(&1[:updated], &2[:updated]) != :gt))
        |> Enum.map(&sanitize_entry(&1, base_url))

      {:ok, %{feed | entries: entries}}
    end
  end

  def parse!(xml) do
    with {:ok, feed} <- parse(xml) do
      feed
    end
  end

  # --


  defp select_parser(xml) do
    cond do
      Atom.valid? xml -> {:ok, Atom}
      RSS1.valid? xml -> {:ok, RSS1}
      RSS2.valid? xml -> {:ok, RSS2}
      true -> {:error, :unknown_feed_format}
    end
  end

  defp extract_base_url(url) do
    %{URI.parse(url) | path: "/"} |> URI.to_string
  end

  defp sanitize_entry(entry, base_url) do
    content =
      (entry.content || "")
      |> String.replace(~r/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/i, "")
      |> Sanitizer.basic_html
      |> String.replace(~r/<\s*img\ssrc\s*=\s*(['"])\//i, "<img src=\\1#{base_url}")

    %{entry | content: content}
  end

end
