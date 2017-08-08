defmodule Feedex.Parsers.RSS1 do
  alias Feedex.Helpers.Xml

  def valid?(xml) do
    Xml.first(xml, "/rdf:RDF/channel") != nil
  end

  def parse(xml) do
    channel = Xml.first(xml, "/rdf:RDF/channel")
    feed = %{
      title:       Xml.first(channel, "title")       |> Xml.text,
      description: Xml.first(channel, "description") |> Xml.text,
      url:         Xml.first(channel, "link")        |> Xml.text,
      updated:     Xml.first(channel, "dc:date")     |> Xml.date,
      entries:     parse_entries(xml),
    }
    {:ok, feed}
  end

  # --

  defp parse_entries(xml) do
    Xml.find(xml, "item") |> Parallel.map(&parse_entry/1)
  end

  defp parse_entry(xml) do
    content = xml |> Xml.first("content:encoded") |> Xml.text
    content = content || xml |> Xml.first("description") |> Xml.text

    %{
      title: xml |> Xml.first("title") |> Xml.text,
      content: content,
      url: xml |> Xml.first("link") |> Xml.text,
      updated: extract_date(xml) || DateTime.utc_now,
    }
  end

  defp extract_date(xml) do
    xml |> Xml.first("dc:date") |> Xml.date
  end
end
