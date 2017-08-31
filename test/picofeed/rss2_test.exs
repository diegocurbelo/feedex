defmodule PicoFeed.RSS2Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{rss_20: File.read!("test/picofeed/fixtures/rss_20.xml") |> Feedex.parse!,
            rss_20_fallback_on_invalid_feed_values: File.read!("test/picofeed/fixtures/rss_20_fallback_on_invalid_feed_values.xml") |> Feedex.parse!,
            rss_20_empty_channel: File.read!("test/picofeed/fixtures/rss_20_empty_channel.xml") |> Feedex.parse!,
            rss_20_empty_feed: File.read!("test/picofeed/fixtures/rss_20_empty_feed.xml") |> Feedex.parse!,
            rss_20_extra: File.read!("test/picofeed/fixtures/rss_20_extra.xml") |> Feedex.parse!("https://feeds.wikipedia.org/category/Russian-language_literature.xml"),
            rss_20_element_preference: File.read!("test/picofeed/fixtures/rss_20_element_preference.xml") |> Feedex.parse!,
            rss_20_fallback_on_invalid_item_values: File.read!("test/picofeed/fixtures/rss_20_fallback_on_invalid_item_values.xml") |> Feedex.parse!,
            rss_20_empty_item: File.read!("test/picofeed/fixtures/rss_20_empty_item.xml") |> Feedex.parse!,
          }}
  end

  test "find feed id", feeds do
    assert feeds[:rss_20].id == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
  end

  test "find feed title", feeds do
    assert feeds[:rss_20].title == "литература на   русском языке, либо написанная русскими авторами"
    assert feeds[:rss_20_fallback_on_invalid_feed_values].title == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:rss_20_empty_channel].title == ""
    assert feeds[:rss_20_empty_feed].title == ""
  end

  test "find feed description", feeds do
    assert feeds[:rss_20].description == "Зародилась во второй половине   X века, однако до XIX века, когда начался её «золотой век», была практически неизвестна в мире."
    assert feeds[:rss_20_empty_channel].description == ""
    assert feeds[:rss_20_empty_feed].description == ""
  end

  test "find feed url", feeds do
    assert feeds[:rss_20].url == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
  end

  test "find site url", feeds do
    assert feeds[:rss_20].site_url == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:rss_20_extra].site_url == "https://feeds.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:rss_20_empty_channel].site_url == ""
    assert feeds[:rss_20_empty_feed].site_url == ""
  end

  test "find feed date", feeds do
    # pubDate
    assert feeds[:rss_20].updated |> Timex.to_unix == 1433451900
    # lastBuildDate
    assert feeds[:rss_20_extra].updated |> Timex.to_unix == 1433451900
    # prefer most recent date and not a particular date element
    assert feeds[:rss_20_element_preference].updated |> Timex.to_unix == 1433455500
  end

  # test "find feed logo", feeds do
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://ru.wikipedia.org/static/images/project-logos/ruwiki.png', $feed->getLogo());
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20_empty_channel.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getLogo());
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20_empty_feed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getLogo());
  # end

  # test "find feed icon", feeds do
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getIcon());
  # end

  # test "find feed language", feeds do
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('ru', $feed->getLanguage());
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20_empty_channel.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getTitle());
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20_empty_feed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getTitle());
  # end

  test "find items tree", feeds do
    assert feeds[:rss_20].entries |> length() == 4
    assert feeds[:rss_20_empty_feed].entries |> length() == 0
  end

  test "find item id", feeds do
    # <guid>
    e1 = feeds[:rss_20].entries |> Enum.at(1)
    assert e1.id == "06E53052CD17CDFB264D9C37D495CC3746AC43F79488C7CE67894E718F674BD5"
    # alternate generation
    e0 = feeds[:rss_20].entries |> Enum.at(0)
    assert e0.id == "DB633F8B8A9166C074B34801428307CEF8FB50D560EBAB3C4CC12A1DBFA3A54D"

    e0 = feeds[:rss_20_empty_item].entries |> Enum.at(0)
    assert e0.id == "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855"
  end

  test "find item title", feeds do
    e0 = feeds[:rss_20].entries |> Enum.at(0)
    assert e0.title == "Война  и мир"

    e2 = feeds[:rss_20_fallback_on_invalid_item_values].entries |> Enum.at(2)
    assert e2.title == "https://en.wikipedia.org/wiki/Doctor_Zhivago_(novel)"

    e0 = feeds[:rss_20_empty_item].entries |> Enum.at(0)
    assert e0.title == ""
  end

  test "find item content", feeds do
    # items[0] === <description>
    # items[1] === <content:encoded>
    e0 = feeds[:rss_20].entries |> Enum.at(0)
    e1 = feeds[:rss_20].entries |> Enum.at(1)
    assert e0.content == "В наброске  предисловия к «Войне и миру» Толстой писал, что в 1856 г. начал писать повесть, «герой которой должен был быть декабрист, возвращающийся с семейством в Россию."
    assert e1.content == "<h1> История  создания </h1> <p> Осенью <a href=\"/wiki/1865_%D0%B3%D0%BE%D0%B4\" title=\"1865 год\"> 1865 года </a> , потеряв все свои деньги в <a href=\"/wiki/%D0%9A%D0%B0%D0%B7%D0%B8%D0%BD%D0%BE\" title=\"Казино\"> казино </a> , не в состоянии оплатить долги кредиторам, и стараясь помочь семье своего брата Михаила, который умер в июле <a href=\"/wiki/1864_%D0%B3%D0%BE%D0%B4\" title=\"1864 год\"> 1864 года </a> , Достоевский планирует создание романа с центральным образом семьи Мармеладовых под названием «Пьяненькая». </p>"

    # <content:encoding> is preferred over <description>
    e1 = feeds[:rss_20_element_preference].entries |> Enum.at(1)
    assert e1.content == "<h1> История  создания </h1> <p> Осенью <a href=\"/wiki/1865_%D0%B3%D0%BE%D0%B4\" title=\"1865 год\"> 1865 года </a> , потеряв все свои деньги в <a href=\"/wiki/%D0%9A%D0%B0%D0%B7%D0%B8%D0%BD%D0%BE\" title=\"Казино\"> казино </a> , не в состоянии оплатить долги кредиторам, и стараясь помочь семье своего брата Михаила, который умер в июле <a href=\"/wiki/1864_%D0%B3%D0%BE%D0%B4\" title=\"1864 год\"> 1864 года </a> , Достоевский планирует создание романа с центральным образом семьи Мармеладовых под названием «Пьяненькая». </p>"

    e1 = feeds[:rss_20_fallback_on_invalid_item_values].entries |> Enum.at(1)
    assert e1.content == "Осенью 1865 года, потеряв  все свои деньги в казино, не в состоянии оплатить долги кредиторам, и стараясь помочь семье своего брата Михаила, который умер в июле 1864 года, Достоевский планирует создание романа с центральным образом семьи Мармеладовых под названием «Пьяненькая»."

    e0 = feeds[:rss_20_empty_item].entries |> Enum.at(0)
    assert e0.content == ""
  end

  test "find item url", feeds do
    e0 = feeds[:rss_20].entries |> Enum.at(0)
    e1 = feeds[:rss_20].entries |> Enum.at(1)
    e2 = feeds[:rss_20].entries |> Enum.at(2)
    e3 = feeds[:rss_20].entries |> Enum.at(3)
    assert e0.url == "https://en.wikipedia.org/wiki/War_and_Peace" # <rss:link>
    assert e1.url == "https://en.wikipedia.org/wiki/Crime_and_Punishment" # <atom:link>
    assert e2.url == "https://en.wikipedia.org/wiki/Doctor_Zhivago_(novel)" # <feedburner:origLink>
    assert e3.url == ""

    # relative urls
    e0 = feeds[:rss_20_extra].entries |> Enum.at(0)
    e1 = feeds[:rss_20_extra].entries |> Enum.at(1)
    e2 = feeds[:rss_20_extra].entries |> Enum.at(2)
    assert e0.url == "https://feeds.wikipedia.org/wiki/War_and_Peace" # <rss:link>
    assert e1.url == "https://feeds.wikipedia.org/wiki/Crime_and_Punishment" # <atom:link>
    assert e2.url == "https://feeds.wikipedia.org/wiki/Doctor_Zhivago_(novel)" # <feedburner:origLink>

    e0 = feeds[:rss_20_element_preference].entries |> Enum.at(0)
    e1 = feeds[:rss_20_element_preference].entries |> Enum.at(1)
    e2 = feeds[:rss_20_element_preference].entries |> Enum.at(2)
    assert e0.url == "https://en.wikipedia.org/wiki/War_and_Peace" # <feedburner:origLink> is preferred over <rss:link>, <atom:link>, <guid>
    assert e1.url == "https://en.wikipedia.org/wiki/Crime_and_Punishment" # <rss:link> is preferred over <atom:link>, <guid>
    assert e2.url == "https://en.wikipedia.org/wiki/Doctor_Zhivago_(novel)" # <atom:link> is preferred over <guid>

    e0 = feeds[:rss_20_fallback_on_invalid_item_values].entries |> Enum.at(0)
    assert e0.url == "" #<guid> is invalid URI

    e0 = feeds[:rss_20_empty_item].entries |> Enum.at(0)
    assert e0.url == ""
  end

  test "find item date", feeds do
    e0 = feeds[:rss_20].entries |> Enum.at(0)
    e1 = feeds[:rss_20].entries |> Enum.at(1)
    assert e0.updated |> Timex.to_unix == 1433451720
    assert e1.updated |> Timex.to_unix == 1433451900
  end

  # test "find item language", feeds do
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('bg', $feed->items[0]->getLanguage()); // item language
  #         $this->assertEquals('ru', $feed->items[1]->getLanguage()); // fallback to feed language
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20_empty_item.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->items[0]->getLanguage());
  # end

  # test "find item categories", feeds do
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20.xml'));
  #         $feed = $parser->execute();
  #         $categories = $feed->items[0]->getCategories();
  #         $this->assertEquals($categories[0], 'Война и мир');
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20_empty_item.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEmpty($feed->items[0]->getCategories());
  # end

  # test "find item author", feeds do
  #         // items[0] === item author
  #         // items[1] === feed author via empty fallback (channel/managingEditor)
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('Лев  Николаевич Толсто́й', $feed->items[0]->getAuthor());
  #         $this->assertEquals('Вики  педии - свободной энциклопедии', $feed->items[1]->getAuthor());
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20_dc.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('Лев  Николаевич Толсто́й', $feed->items[0]->getAuthor());
  #         $this->assertEquals('Вики  педии - свободной энциклопедии', $feed->items[1]->getAuthor());
  #         // <dc:creator> is preferred over <author>
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20_element_preference.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('Лев  Николаевич Толсто́й', $feed->items[0]->getAuthor());
  #         $this->assertEquals('Вики  педии - свободной энциклопедии', $feed->items[1]->getAuthor());
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20_empty_item.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->items[0]->getAuthor());
  # end

  # test "find item enclosure", feeds do
  #         // Test tests covers the preference of <feedburner:origEnclosureLink> over <enclosure> as well
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://upload.wikimedia.org/wikipedia/commons/4/41/War-and-peace_1873.gif', $feed->items[0]->getEnclosureUrl()); // <enclosure>
  #         $this->assertEquals('image/gif', $feed->items[0]->getEnclosureType());
  #         $this->assertEquals('https://upload.wikimedia.org/wikipedia/commons/7/7b/Crime_and_Punishment-1.png', $feed->items[1]->getEnclosureUrl()); // <feedburner:origEnclosureLink>
  #         $parser = new Rss20(file_get_contents('tests/fixtures/rss_20_empty_item.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->items[0]->getEnclosureUrl());
  #         $this->assertEquals('', $feed->items[0]->getEnclosureType());
  # end

end
