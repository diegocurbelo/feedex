defmodule PicoFeed.RSS1Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{rss_10: File.read!("test/picofeed/fixtures/rss_10.xml") |> Feedex.parse!,
            heise: File.read!("test/picofeed/fixtures/heise.rdf") |> Feedex.parse!,
            rss_10_no_default_namespace: File.read!("test/picofeed/fixtures/rss_10_no_default_namespace.xml") |> Feedex.parse!,
            rss_10_prefixed: File.read!("test/picofeed/fixtures/rss_10_prefixed.xml") |> Feedex.parse!,
            rss_10_fallback_on_invalid_feed_values: File.read!("test/picofeed/fixtures/rss_10_fallback_on_invalid_feed_values.xml") |> Feedex.parse!,
            rss_10_empty_channel: File.read!("test/picofeed/fixtures/rss_10_empty_channel.xml") |> Feedex.parse!(),
            rss_10_empty_feed: File.read!("test/picofeed/fixtures/rss_10_empty_feed.xml") |> Feedex.parse!,
            rss_10_extra: File.read!("test/picofeed/fixtures/rss_10_extra.xml") |> Feedex.parse!("https://feeds.wikipedia.org/category/Russian-language_literature.xml"),
            rss_10_empty_item: File.read!("test/picofeed/fixtures/rss_10_empty_item.xml") |> Feedex.parse!,
            rss_10_fallback_on_invalid_item_values: File.read!("test/picofeed/fixtures/rss_10_fallback_on_invalid_item_values.xml") |> Feedex.parse!,
            rss_10_element_preference: File.read!("test/picofeed/fixtures/rss_10_element_preference.xml") |> Feedex.parse!,
          }}
  end

  test "find feed id", feeds do
    assert feeds[:rss_10].id == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:heise].id == "http://www.heise.de/newsticker/"
  end

  test "find feed title", feeds do
    assert feeds[:rss_10].title == "литература на   русском языке, либо написанная русскими авторами"
    assert feeds[:rss_10_no_default_namespace].title == "литература на   русском языке, либо написанная русскими авторами"
    assert feeds[:rss_10_prefixed].title == "литература на   русском языке, либо написанная русскими авторами"
    assert feeds[:rss_10_fallback_on_invalid_feed_values].title == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:rss_10_empty_channel].title == ""
    assert feeds[:rss_10_empty_feed].title == ""
    assert feeds[:heise].title == "heise online News"
  end

  test "find feed description", feeds do
    assert feeds[:rss_10].description == "Зародилась во второй половине   X века, однако до XIX века, когда начался её «золотой век», была практически неизвестна в мире."
    assert feeds[:rss_10_no_default_namespace].description == "Зародилась во второй половине   X века, однако до XIX века, когда начался её «золотой век», была практически неизвестна в мире."
    assert feeds[:rss_10_prefixed].description == "Зародилась во второй половине   X века, однако до XIX века, когда начался её «золотой век», была практически неизвестна в мире."
    assert feeds[:rss_10_empty_channel].description == ""
    assert feeds[:rss_10_empty_feed].description == ""
    assert feeds[:heise].description == "Nachrichten nicht nur aus der Welt der Computer"
  end

  test "find feed url", feeds do
    assert feeds[:rss_10].url == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
  end

  test "find site url", feeds do
    assert feeds[:rss_10].site_url == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:rss_10_extra].site_url == "https://feeds.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:rss_10_no_default_namespace].site_url == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:rss_10_prefixed].site_url == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:rss_10_empty_channel].site_url == ""
    assert feeds[:rss_10_empty_feed].site_url == ""
    assert feeds[:heise].site_url == "http://www.heise.de/newsticker/"
  end

  test "find feed date", feeds do
    assert feeds[:rss_10].updated |> Timex.to_unix == 1433451900
    assert feeds[:rss_10_no_default_namespace].updated |> Timex.to_unix == 1433451900
    assert feeds[:rss_10_prefixed].updated |> Timex.to_unix == 1433451900
  end

  # test "find feed logo", feeds do
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://ru.wikipedia.org/static/images/project-logos/ruwiki.png', $feed->getLogo());
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10_no_default_namespace.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://ru.wikipedia.org/static/images/project-logos/ruwiki.png', $feed->getLogo());
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10_prefixed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://ru.wikipedia.org/static/images/project-logos/ruwiki.png', $feed->getLogo());
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10_empty_channel.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getLogo());
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10_empty_feed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getLogo());
  # end

  # test "find feed icon", feeds do
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getIcon());
  # end

  # test "find feed language", feeds do
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('ru', $feed->getLanguage());
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10_no_default_namespace.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('ru', $feed->getLanguage());
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10_prefixed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('ru', $feed->getLanguage());
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10_empty_channel.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getTitle());
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10_empty_feed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getTitle());
  # end

  test "find items tree", feeds do
    assert feeds[:rss_10].entries |> length() == 2
    assert feeds[:rss_10_no_default_namespace].entries |> length() == 3
    assert feeds[:rss_10_prefixed].entries |> length() == 1
    assert feeds[:rss_10_empty_feed].entries |> length() == 0
    assert feeds[:heise].entries |> length() == 60
  end

  test "find item id", feeds do
    e0 = feeds[:rss_10].entries |> Enum.at(0)
    assert e0.id == "DB633F8B8A9166C074B34801428307CEF8FB50D560EBAB3C4CC12A1DBFA3A54D"

    e0 = feeds[:rss_10_empty_item].entries |> Enum.at(0)
    assert e0.id == "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855"

    e0 = feeds[:heise].entries |> Enum.at(0)
    assert e0.id == "86F8961705A56FED5F46FF1A013A2429F4DE3D617048B8151E7F6FA0A2ABB985"
  end

  test "find item title", feeds do
    e0 = feeds[:rss_10].entries |> Enum.at(0)
    assert e0.title == "Война  и мир"

    e0 = feeds[:rss_10_no_default_namespace].entries |> Enum.at(0)
    assert e0.title == "Война  и мир"

    e0 = feeds[:rss_10_prefixed].entries |> Enum.at(0)
    assert e0.title == "Война  и мир"

    e2 = feeds[:rss_10_fallback_on_invalid_item_values].entries |> Enum.at(2)
    assert e2.title == "https://en.wikipedia.org/wiki/Doctor_Zhivago_(novel)"

    e0 = feeds[:rss_10_empty_item].entries |> Enum.at(0)
    assert e0.title == ""

    e0 = feeds[:heise].entries |> Enum.at(0)
    assert e0.title == "Facebook f8: Künstliche Intelligenz räumt den Newsfeed auf"
  end

  test "find item content", feeds do
    e0 = feeds[:rss_10].entries |> Enum.at(0)
    e1 = feeds[:rss_10].entries |> Enum.at(1)
    assert e0.content |> String.starts_with?("В наброске  предисловия к «Войне и миру» Толстой писал, что в 1856 г.")
    assert e1.content |> String.starts_with?("<h1> История  создания </h1> <p> Осенью <a href=\"/wiki/1865_%D0%B3%D0%BE%D0%B4\"")

    e0 = feeds[:rss_10_no_default_namespace].entries |> Enum.at(0)
    assert e0.content |> String.starts_with?("В наброске  предисловия к «Войне и миру» Толстой писал, что в 1856 г.")

    e0 = feeds[:rss_10_prefixed].entries |> Enum.at(0)
    assert e0.content |> String.starts_with?("В наброске  предисловия к «Войне и миру» Толстой писал, что в 1856 г.")

    e1 = feeds[:rss_10_element_preference].entries |> Enum.at(1)
    assert e1.content |> String.starts_with?("<h1> История  создания </h1> <p> Осенью <a href=\"/wiki/1865_%D0%B3%D0%BE%D0%B4\"")

    e1 = feeds[:rss_10_fallback_on_invalid_item_values].entries |> Enum.at(1)
    assert e1.content == "Осенью 1865 года, потеряв  все свои деньги в казино, не в состоянии оплатить долги кредиторам, и стараясь помочь семье своего брата Михаила, который умер в июле 1864 года, Достоевский планирует создание романа с центральным образом семьи Мармеладовых под названием «Пьяненькая»."

    e2 = feeds[:rss_10_no_default_namespace].entries |> Enum.at(2)
    assert e2.content == ""

    e0 = feeds[:heise].entries |> Enum.at(0)
    assert e0.content == "Die Keynotes des zweiten Tags von Facebooks Entwicklerkonferenz haben gezeigt, an wievielen Stellen das Unternehmen künstliche Intelligenz bereits einsetzt oder damit experimentiert."
  end

  test "find item url", feeds do
    e0 = feeds[:rss_10].entries |> Enum.at(0)
    e1 = feeds[:rss_10].entries |> Enum.at(1)
    assert e0.url == "https://en.wikipedia.org/wiki/War_and_Peace" # <rss:link>
    assert e1.url == "https://en.wikipedia.org/wiki/Crime_and_Punishment" # <feedburner:origLink>

    e0 = feeds[:rss_10_extra].entries |> Enum.at(0)
    e1 = feeds[:rss_10_extra].entries |> Enum.at(1)
    assert e0.url == "https://feeds.wikipedia.org/wiki/War_and_Peace" # <rss:link>
    assert e1.url == "https://feeds.wikipedia.org/wiki/Crime_and_Punishment" # <feedburner:origLink>

    e0 = feeds[:rss_10_no_default_namespace].entries |> Enum.at(0)
    assert e0.url == "https://en.wikipedia.org/wiki/War_and_Peace" # <rss:link>

    e0 = feeds[:rss_10_prefixed].entries |> Enum.at(0)
    assert e0.url == "https://en.wikipedia.org/wiki/War_and_Peace" # <rss:link>

    e0 = feeds[:rss_10_element_preference].entries |> Enum.at(0)
    assert e0.url == "https://en.wikipedia.org/wiki/War_and_Peace" # <feedburner:origLink> is preferred over <rss:link>

    e0 = feeds[:rss_10_empty_item].entries |> Enum.at(0)
    assert e0.url == ""

    e0 = feeds[:heise].entries |> Enum.at(0)
    assert e0.url == "http://www.heise.de/newsticker/meldung/Facebook-f8-Kuenstliche-Intelligenz-raeumt-den-Newsfeed-auf-3173304.html?wt_mc=rss.ho.beitrag.rdf"
  end

  test "find item date", feeds do
    e0 = feeds[:rss_10].entries |> Enum.at(0)
    e1 = feeds[:rss_10].entries |> Enum.at(1)
    assert e0.updated |> Timex.to_unix == 1433451720 # item date
    assert e1.updated |> Timex.to_unix == 1433451900 # fallback to feed date
  end

  # test "find item language", feeds do
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('bg', $feed->items[0]->getLanguage()); // item language
  #         $this->assertEquals('ru', $feed->items[1]->getLanguage()); // fallback to feed language
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10_empty_item.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->items[0]->getAuthor());
  # end

  # test "find item categories", feeds do
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10.xml'));
  #         $feed = $parser->execute();
  #         $categories = $feed->items[0]->getCategories();
  #         $this->assertEquals($categories[0], 'Война и мир');
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10_empty_item.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEmpty($feed->items[0]->getCategories());
  # end

  # test "find item author", feeds do
  #         // items[0] === item author
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('Лев  Николаевич Толсто́й', $feed->items[0]->getAuthor());
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10_empty_item.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->items[0]->getAuthor());
  # end

  # test "find item enclosure", feeds do
  #         $parser = new Rss10(file_get_contents('tests/fixtures/rss_10.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->items[0]->getEnclosureUrl());
  #         $this->assertEquals('', $feed->items[0]->getEnclosureType());
  # end

end
