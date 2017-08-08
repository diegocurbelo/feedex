defmodule Feedex.Parsers.Atom do
  alias Feedex.Helpers.Xml

  def valid?(xml) do
    Xml.first(xml, "/feed") != nil
  end

  def parse(xml) do
    channel = Xml.first(xml, "/feed")

    url = channel |> Xml.first("link") |> Xml.attr("href")
    url = url || channel |> Xml.first("atom10:link") |> Xml.attr("href")

    feed = %{
      title:       Xml.first(channel, "title")    |> Xml.text,
      description: Xml.first(channel, "subtitle") |> Xml.text,
      url: url,
      updated:     Xml.first(channel, "updated")  |> Xml.date,
      entries:     parse_entries(channel),
    }
    {:ok, feed}
  end

  # --

  defp parse_entries(xml) do
    Xml.find(xml, "entry") |> Parallel.map(&parse_entry/1)
  end

  defp parse_entry(xml) do
    content = xml |> Xml.first("content") |> Xml.text
    content = content || xml |> Xml.first("summary") |> Xml.text

    %{
      title: xml |> Xml.first("title") |> Xml.text,
      content: content,
      url: xml |> Xml.first("link") |> Xml.attr("href"),
      updated: extract_date(xml) || DateTime.utc_now,
    }
  end

  defp extract_date(xml) do
    xml |> Xml.first("updated") |> Xml.date
  end
end
