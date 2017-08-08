defmodule FeedexTest do
  use ExUnit.Case
  doctest Feedex

  test "parse an Feedburner feed" do
    xml = File.read! "test/samples/elixir_lang.xml"
    {:ok, feed} = Feedex.parse(xml)
    assert feed.title == "Elixir Lang"
    assert feed.description == nil
    assert feed.url == "http://elixir-lang.org"
    assert feed.updated == Timex.parse!("Sun, 06 Aug 2017 10:29:16 GMT", "{RFC1123}")
    assert length(feed.entries) == 26
  end

  test "parse an RSS2 feed" do
    xml = File.read! "test/samples/techcrunch.xml"
    {:ok, feed} = Feedex.parse(xml)
    assert feed.title == "TechCrunch"
    assert feed.description == "Startup and Technology News"
    assert feed.url == "https://techcrunch.com"
    assert feed.updated == nil
    assert length(feed.entries) == 20
  end

  test "parse an RSS2 feed 2" do
    xml = File.read! "test/samples/montevideo_com.xml"
    {:ok, feed} = Feedex.parse(xml)
    assert feed.title == "Montevideo Portal - Canal de Noticias"
    assert feed.description == "Montevideo Portal - Canal de Noticias"
    assert feed.url == "http://www.montevideo.com.uy"
    assert feed.updated == nil
    assert length(feed.entries) == 8
  end

end
