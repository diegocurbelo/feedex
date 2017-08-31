defmodule Feedex.Parsers.RSS1 do
  @moduledoc false

  import SweetXml
  import Feedex.Helpers.Xml

  @schema [
    title:         ~x'/rdf:RDF/channel/title/text()'s |> transform_by(&strip/1),
    rss_title:     ~x'/rdf:RDF/rss:channel/rss:title/text()'s |> transform_by(&strip/1),
    description:     ~x'/rdf:RDF/channel/description/text()'s |> transform_by(&strip/1),
    rss_description: ~x'/rdf:RDF/rss:channel/rss:description/text()'s |> transform_by(&strip/1),
    url:            ~x'/rdf:RDF/channel/link/text()'s |> transform_by(&strip/1),
    rss_url:        ~x'/rdf:RDF/rss:channel/rss:link/text()'s |> transform_by(&strip/1),
    updated:       ~x'/rdf:RDF/channel/dc:date/text()'s |> transform_by(&parse_date/1),
    rss_updated:   ~x'/rdf:RDF/rss:channel/dc:date/text()'s |> transform_by(&parse_date/1),
    entries: [ ~x'/rdf:RDF/item | /rdf:RDF/rss:item'l,
      title:        ~x'./title/text()'s |> transform_by(&strip/1),
      rss_title:    ~x'./rss:title/text()'s |> transform_by(&strip/1),
      url:          ~x'./link/text()'s |> transform_by(&strip/1),
      rss_url:      ~x'./rss:link/text()'s |> transform_by(&strip/1),
      url_orig:     ~x'./feedburner:origLink/text()'s |> transform_by(&strip/1),
      content:           ~x'./description/text()'s |> transform_by(&strip/1),
      rss_content:       ~x'./rss:description/text()'s |> transform_by(&strip/1),
      encoded_content:   ~x'./content:encoded/text()'s |> transform_by(&strip/1),
      updated:           ~x'./dc:date/text()'s |> transform_by(&parse_date/1),
    ]
  ]

  def valid?(doc) do
    doc |> xpath(~x"/rdf:RDF"e) != nil
  end

  def parse(doc, url) do
    feed = SweetXml.xmap(doc, @schema)

    # Need to get the real feed url, so the relative uris can be composed correctly
    url = get_feed_url(feed, url)
    base_url = get_base_url(url)
    updated = get_feed_date(feed)

    parsed_feed =
      %{id:          get_feed_id(feed) || "",
        title:       get_feed_title(feed) || url,
        description: get_feed_description(feed) || "",
        url:         url,
        site_url:    url,
        updated:     updated,
        entries:     feed.entries |> Enum.map(&get_entry(&1, base_url, updated))
      }

    {:ok, parsed_feed}
  end

  # --

  defp get_feed_id(feed) do
    cond do
      "" != feed.url      -> feed.url
      "" != feed.rss_url  -> feed.rss_url
      true -> nil
    end
  end

  defp get_feed_title(feed) do
    cond do
      "" != feed.title      -> feed.title |> strip
      "" != feed.rss_title -> feed.rss_title |> strip
      true -> nil
    end
  end

  defp get_feed_description(feed) do
    cond do
      "" != feed.description     -> feed.description |> strip
      "" != feed.rss_description -> feed.rss_description |> strip
      true -> nil
    end
  end

  defp get_feed_url(feed, url) do
    cond do
      "" != feed.url      -> feed.url |> expand_relative_url(get_base_url(url))
      "" != feed.rss_url  -> feed.rss_url |> expand_relative_url(get_base_url(url))
      true -> url
    end
  end

  defp get_feed_date(feed) do
    cond do
      feed.updated     -> feed.updated
      feed.rss_updated -> feed.rss_updated
      true -> Timex.now
    end
  end

  defp get_entry(entry, base_url, feed_date) do
    title = get_entry_title(entry)
    url = get_entry_url(entry, base_url)
    content = get_entry_content(entry)

    id = title <> url <> content

    %{
      id:      :crypto.hash(:sha256, id) |> Base.encode16,
      title:   title != "" && title || url,
      url:     url,
      content: content,
      updated: get_entry_date(entry, feed_date)
    }
  end

  defp get_entry_title(entry) do
    cond do
      "" != entry.title     -> entry.title |> strip
      "" != entry.rss_title -> entry.rss_title |> strip
      true -> ""
    end
  end

  defp get_entry_url(entry, base_url) do
    cond do
      "" != entry.url_orig -> entry.url_orig |> expand_relative_url(base_url)
      "" != entry.url      -> entry.url |> expand_relative_url(base_url)
      "" != entry.rss_url  -> entry.rss_url |> expand_relative_url(base_url)
      true -> ""
    end
  end

  defp get_entry_content(entry) do
    cond do
      "" != entry.encoded_content      -> entry.encoded_content |> strip
      "" != entry.content     -> entry.content |> strip
      "" != entry.rss_content -> entry.rss_content |> strip
      true -> ""
    end
  end

  defp get_entry_date(entry, feed_date) do
    cond do
      entry.updated        -> entry.updated
      true -> feed_date
    end
  end

end
