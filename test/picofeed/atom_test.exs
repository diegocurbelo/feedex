defmodule PicoFeed.AtomTest do
  use ExUnit.Case

  setup_all do
    {:ok, %{atom: File.read!("test/picofeed/fixtures/atom.xml") |> Feedex.parse!,
            atom_no_default_namespace: File.read!("test/picofeed/fixtures/atom_no_default_namespace.xml") |> Feedex.parse!,
            atom_prefixed: File.read!("test/picofeed/fixtures/atom_prefixed.xml") |> Feedex.parse!,
            atom_empty_feed: File.read!("test/picofeed/fixtures/atom_empty_feed.xml") |> Feedex.parse!,
            atom_fallback_on_invalid_feed_values: File.read!("test/picofeed/fixtures/atom_fallback_on_invalid_feed_values.xml") |> Feedex.parse!,
            atom_extra: File.read!("test/picofeed/fixtures/atom_extra.xml") |> Feedex.parse!("https://feeds.wikipedia.org/category/Russian-language_literature.xml"),
            atom_empty_item: File.read!("test/picofeed/fixtures/atom_empty_item.xml") |> Feedex.parse!,
            atom_fallback_on_invalid_item_values: File.read!("test/picofeed/fixtures/atom_fallback_on_invalid_item_values.xml") |> Feedex.parse!,
            atom_element_preference: File.read!("test/picofeed/fixtures/atom_element_preference.xml") |> Feedex.parse!,
          }}
  end

  test "find feed id", feeds do
    assert feeds[:atom].id == "urn:uuid:bd0b2c90-35a3-44e9-a491-4e15508f6d83"
    assert feeds[:atom_no_default_namespace].id == "urn:uuid:bd0b2c90-35a3-44e9-a491-4e15508f6d83"
    assert feeds[:atom_prefixed].id == "urn:uuid:bd0b2c90-35a3-44e9-a491-4e15508f6d83"
    assert feeds[:atom_empty_feed].id == ""
  end

  test "find feed title", feeds do
    assert feeds[:atom].title == "литература на   русском языке,  либо написанная русскими авторами"
    assert feeds[:atom_no_default_namespace].title == "литература на   русском языке,  либо написанная русскими авторами"
    assert feeds[:atom_prefixed].title == "литература на   русском языке,  либо написанная русскими авторами"
    assert feeds[:atom_empty_feed].title == ""
    assert feeds[:atom_fallback_on_invalid_feed_values].title == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
  end

  test "find feed description", feeds do
    assert feeds[:atom].description == "Зародилась во второй половине   X века, однако до XIX века, когда начался её «золотой век», была практически неизвестна в мире."
    assert feeds[:atom_no_default_namespace].description == "Зародилась во второй половине   X века, однако до XIX века, когда начался её «золотой век», была практически неизвестна в мире."
    assert feeds[:atom_prefixed].description == "Зародилась во второй половине   X века, однако до XIX века, когда начался её «золотой век», была практически неизвестна в мире."
    assert feeds[:atom_empty_feed].description == ""
  end

  test "find feed url", feeds do
    assert feeds[:atom].url == "https://feeds.wikipedia.org/category/Russian-language_literature.xml"
    assert feeds[:atom_extra].url == "https://feeds.wikipedia.org/category/Russian-language_literature.xml"
    assert feeds[:atom_prefixed].url == "https://feeds.wikipedia.org/category/Russian-language_literature.xml"
    assert feeds[:atom_prefixed].url == "https://feeds.wikipedia.org/category/Russian-language_literature.xml"
    assert feeds[:atom_empty_feed].url == ""
  end

  test "find site url", feeds do
    assert feeds[:atom].site_url == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:atom_extra].site_url == "https://feeds.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:atom_no_default_namespace].site_url == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:atom_prefixed].site_url == "https://en.wikipedia.org/wiki/Category:Russian-language_literature"
    assert feeds[:atom_empty_feed].site_url == ""
  end

  test "find feed date", feeds do
    assert feeds[:atom].updated |> Timex.to_unix == 1433451900
    assert feeds[:atom_no_default_namespace].updated |> Timex.to_unix == 1433451900
    assert feeds[:atom_prefixed].updated |> Timex.to_unix == 1433451900
  end

  # test "find feed logo", feeds do
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://ru.wikipedia.org/static/images/project-logos/ruwiki.png', $feed->getLogo());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_no_default_namespace.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://ru.wikipedia.org/static/images/project-logos/ruwiki.png', $feed->getLogo());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_prefixed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://ru.wikipedia.org/static/images/project-logos/ruwiki.png', $feed->getLogo());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_empty_feed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getLogo());
  # end

  # test "find feed icon", feeds do
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://ru.wikipedia.org/static/favicon/wikipedia.ico', $feed->getIcon());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_no_default_namespace.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://ru.wikipedia.org/static/favicon/wikipedia.ico', $feed->getIcon());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_prefixed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://ru.wikipedia.org/static/favicon/wikipedia.ico', $feed->getIcon());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_empty_feed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getIcon());
  # end

  # test "find feed language", feeds do
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('ru', $feed->getLanguage());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_extra.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('ru', $feed->getLanguage());
  #         // do not use lang from entry or descendant of entry
  #         $parser = new Atom('<feed xmlns="http://www.w3.org/2005/Atom"><entry xml:lang="ru"><title xml:lang="ru"/></entry></feed>');
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getLanguage());
  #         // do not use lang from entry or descendant of entry (prefixed)
  #         $parser = new Atom('<feed xmlns:atom="http://www.w3.org/2005/Atom"><atom:entry xml:lang="ru"><atom:title xml:lang="ru"/></atom:entry></feed>');
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getLanguage());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_no_default_namespace.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('ru', $feed->getLanguage());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_prefixed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('ru', $feed->getLanguage());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_empty_feed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->getLanguage());
  # end

  test "find items tree", feeds do
    assert feeds[:atom].entries |> length() == 4
    assert feeds[:atom_no_default_namespace].entries |> length() == 4
    assert feeds[:atom_prefixed].entries |> length() == 4
    assert feeds[:atom_empty_feed].entries |> length() == 0
  end

  test "find item id", feeds do
    e0 = feeds[:atom].entries |> Enum.at(0)
    e1 = feeds[:atom].entries |> Enum.at(1)
    assert e0.id == "DB633F8B8A9166C074B34801428307CEF8FB50D560EBAB3C4CC12A1DBFA3A54D"
    assert e1.id == "B64B5E0CE422566FA768E8C66DA61AB5759C00B2289ADBE8FE2F35ECFE211184"

    e0 = feeds[:atom_no_default_namespace].entries |> Enum.at(0)
    e1 = feeds[:atom_no_default_namespace].entries |> Enum.at(1)
    assert e0.id == "DB633F8B8A9166C074B34801428307CEF8FB50D560EBAB3C4CC12A1DBFA3A54D"
    assert e1.id == "B64B5E0CE422566FA768E8C66DA61AB5759C00B2289ADBE8FE2F35ECFE211184"

    e0 = feeds[:atom_prefixed].entries |> Enum.at(0)
    e1 = feeds[:atom_prefixed].entries |> Enum.at(1)
    assert e0.id == "DB633F8B8A9166C074B34801428307CEF8FB50D560EBAB3C4CC12A1DBFA3A54D"
    assert e1.id == "B64B5E0CE422566FA768E8C66DA61AB5759C00B2289ADBE8FE2F35ECFE211184"

    e0 = feeds[:atom_empty_item].entries |> Enum.at(0)
    assert e0.id == "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855"
  end

  test "find item title", feeds do
    e0 = feeds[:atom].entries |> Enum.at(0)
    assert e0.title == "Война  и мир"

    e0 = feeds[:atom_no_default_namespace].entries |> Enum.at(0)
    assert e0.title == "Война  и мир"

    e0 = feeds[:atom_prefixed].entries |> Enum.at(0)
    assert e0.title == "Война  и мир"

    e2 = feeds[:atom_fallback_on_invalid_item_values].entries |> Enum.at(2)
    assert e2.title == "https://en.wikipedia.org/wiki/Doctor_Zhivago_(novel)"

    e0 = feeds[:atom_empty_item].entries |> Enum.at(0)
    assert e0.title == ""
  end

  test "find item content", feeds do
    e0 = feeds[:atom].entries |> Enum.at(0)
    e1 = feeds[:atom].entries |> Enum.at(1)
    e2 = feeds[:atom].entries |> Enum.at(2)
    e3 = feeds[:atom].entries |> Enum.at(3)
    assert e0.content |> String.starts_with?("В наброске  предисловия к «Войне и миру» Толстой писал, что в 1856 г.")
    assert e1.content |> String.starts_with?("<h1>  История  создания  </h1>  <p>  Осенью   <a href=\"/wiki/1865_%D0%B3%D0%BE%D0%B4\"")
    assert e2.content |> String.starts_with?("<h1> Доктор Живаго </h1> <p> <b>«До́ктор Жива́го»</b>")
    assert e3.content |> String.starts_with?("<h1> Герой нашего времени </h1> <p> <b>«Геро́й на́шего вре́мени»</b>  (написан в 1838—1840) — знаменитый роман  <a href=\"/wiki/%D0%9B")

    e0 = feeds[:atom_no_default_namespace].entries |> Enum.at(0)
    e1 = feeds[:atom_no_default_namespace].entries |> Enum.at(1)
    e2 = feeds[:atom_no_default_namespace].entries |> Enum.at(2)
    e3 = feeds[:atom_no_default_namespace].entries |> Enum.at(3)
    assert e0.content |> String.starts_with?("В наброске  предисловия к «Войне и миру» Толстой писал, что в 1856 г.")
    assert e1.content |> String.starts_with?("<h1>  История  создания  </h1>  <p>  Осенью   <a href=\"/wiki/1865_%D0%B3%D0%BE%D0%B4\"")
    assert e2.content |> String.starts_with?("<h1> Доктор Живаго </h1> <p> <b>«До́ктор Жива́го»</b>")
    assert e3.content |> String.starts_with?("<h1> Герой нашего времени </h1> <p> <b>«Геро́й на́шего вре́мени»</b>  (написан в 1838—1840) — знаменитый роман  <a href=\"/wiki/%D0%9B")

    e0 = feeds[:atom_prefixed].entries |> Enum.at(0)
    e1 = feeds[:atom_prefixed].entries |> Enum.at(1)
    e2 = feeds[:atom_prefixed].entries |> Enum.at(2)
    e3 = feeds[:atom_prefixed].entries |> Enum.at(3)
    assert e0.content |> String.starts_with?("В наброске  предисловия к «Войне и миру» Толстой писал, что в 1856 г.")
    assert e1.content |> String.starts_with?("<h1>  История  создания  </h1>  <p>  Осенью   <a href=\"/wiki/1865_%D0%B3%D0%BE%D0%B4\"")
    assert e2.content |> String.starts_with?("<h1> Доктор Живаго </h1> <p> <b>«До́ктор Жива́го»</b>")
    assert e3.content |> String.starts_with?("<h1> Герой нашего времени </h1> <p> <b>«Геро́й на́шего вре́мени»</b>  (написан в 1838—1840) — знаменитый роман  <a href=\"/wiki/%D0%9B")

    e1 = feeds[:atom_element_preference].entries |> Enum.at(1)
    assert e1.content |> String.starts_with?("<h1> История  создания </h1> <p> Осенью <a href=\"/wiki/1865_%D0%B3%D0%BE%D0%B4\"")

    e1 = feeds[:atom_fallback_on_invalid_item_values].entries |> Enum.at(1)
    assert e1.content |> String.starts_with?("Осенью 1865 года, потеряв  все свои деньги в казино")

    e0 = feeds[:atom_empty_item].entries |> Enum.at(0)
    assert e0.content == ""
  end

  test "find item url", feeds do
    e0 = feeds[:atom].entries |> Enum.at(0)
    e1 = feeds[:atom].entries |> Enum.at(1)
    assert e0.url == "https://en.wikipedia.org/wiki/War_and_Peace"
    assert e1.url == "https://en.wikipedia.org/wiki/Crime_and_Punishment"

    e0 = feeds[:atom_extra].entries |> Enum.at(0)
    e1 = feeds[:atom_extra].entries |> Enum.at(1)
    assert e0.url == "https://feeds.wikipedia.org/wiki/War_and_Peace"
    assert e1.url == "https://feeds.wikipedia.org/wiki/Crime_and_Punishment"

    e0 = feeds[:atom_no_default_namespace].entries |> Enum.at(0)
    e1 = feeds[:atom_no_default_namespace].entries |> Enum.at(1)
    assert e0.url == "https://en.wikipedia.org/wiki/War_and_Peace"
    assert e1.url == "https://en.wikipedia.org/wiki/Crime_and_Punishment"

    e0 = feeds[:atom_prefixed].entries |> Enum.at(0)
    e1 = feeds[:atom_prefixed].entries |> Enum.at(1)
    assert e0.url == "https://en.wikipedia.org/wiki/War_and_Peace"
    assert e1.url == "https://en.wikipedia.org/wiki/Crime_and_Punishment"

    e0 = feeds[:atom_empty_item].entries |> Enum.at(0)
    assert e0.url == ""
  end

  test "find item date", feeds do
    e0 = feeds[:atom].entries |> Enum.at(0)
    e1 = feeds[:atom].entries |> Enum.at(1)
    e2 = feeds[:atom].entries |> Enum.at(2)
    assert e0.updated |> Timex.to_unix == 1433451720
    assert e1.updated |> Timex.to_unix == 1433451720
    assert e2.updated |> Timex.to_unix == 1433451900

    e0 = feeds[:atom_no_default_namespace].entries |> Enum.at(0)
    e1 = feeds[:atom_no_default_namespace].entries |> Enum.at(1)
    e2 = feeds[:atom_no_default_namespace].entries |> Enum.at(2)
    assert e0.updated |> Timex.to_unix == 1433451720
    assert e1.updated |> Timex.to_unix == 1433451720
    assert e2.updated |> Timex.to_unix == 1433451900

    e0 = feeds[:atom_prefixed].entries |> Enum.at(0)
    e1 = feeds[:atom_prefixed].entries |> Enum.at(1)
    e2 = feeds[:atom_prefixed].entries |> Enum.at(2)
    assert e0.updated |> Timex.to_unix == 1433451720
    assert e1.updated |> Timex.to_unix == 1433451720
    assert e2.updated |> Timex.to_unix == 1433451900

    e0 = feeds[:atom_element_preference].entries |> Enum.at(0)
    assert e0.updated |> Timex.to_unix == 1433451900
  end

  # test "find item language", feeds do
  #         // items[0] === language tag on Language-Sensitive element (title)
  #         // items[1] === language tag on root node
  #         // items[2] === fallback to feed language
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('bg', $feed->items[0]->getLanguage());
  #         $this->assertEquals('bg', $feed->items[1]->getLanguage());
  #         $this->assertEquals('ru', $feed->items[2]->getLanguage());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_no_default_namespace.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('bg', $feed->items[0]->getLanguage());
  #         $this->assertEquals('bg', $feed->items[1]->getLanguage());
  #         $this->assertEquals('ru', $feed->items[2]->getLanguage());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_prefixed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('bg', $feed->items[0]->getLanguage());
  #         $this->assertEquals('bg', $feed->items[1]->getLanguage());
  #         $this->assertEquals('ru', $feed->items[2]->getLanguage());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_empty_item.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->items[0]->getLanguage());
  # end

  # test "find item categories", feeds do
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom.xml'));
  #         $feed = $parser->execute();
  #         $categories = $feed->items[0]->getCategories();
  #         $this->assertEquals($categories[0], 'Война и мир');
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_no_default_namespace.xml'));
  #         $feed = $parser->execute();
  #         $categories = $feed->items[0]->getCategories();
  #         $this->assertEquals($categories[0], 'Война и мир');
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_prefixed.xml'));
  #         $feed = $parser->execute();
  #         $categories = $feed->items[0]->getCategories();
  #         $this->assertEquals($categories[0], 'Война и мир');
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_empty_item.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEmpty($feed->items[0]->getCategories());
  # end

  # test "find item author", feeds do
  #         // items[0] === item author
  #         // items[1] === feed author via empty fallback
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('Лев  Николаевич Толсто́й', $feed->items[0]->getAuthor());
  #         $this->assertEquals('Вики  педии - свободной энциклопедии', $feed->items[1]->getAuthor());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_no_default_namespace.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('Лев  Николаевич Толсто́й', $feed->items[0]->getAuthor());
  #         $this->assertEquals('Вики  педии - свободной энциклопедии', $feed->items[1]->getAuthor());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_prefixed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('Лев  Николаевич Толсто́й', $feed->items[0]->getAuthor());
  #         $this->assertEquals('Вики  педии - свободной энциклопедии', $feed->items[1]->getAuthor());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_empty_item.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->items[0]->getAuthor());
  # end

  # test "find item enclosure", feeds do
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://upload.wikimedia.org/wikipedia/commons/4/41/War-and-peace_1873.gif', $feed->items[0]->getEnclosureUrl());
  #         $this->assertEquals('image/gif', $feed->items[0]->getEnclosureType());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_no_default_namespace.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://upload.wikimedia.org/wikipedia/commons/4/41/War-and-peace_1873.gif', $feed->items[0]->getEnclosureUrl());
  #         $this->assertEquals('image/gif', $feed->items[0]->getEnclosureType());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_prefixed.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('https://upload.wikimedia.org/wikipedia/commons/4/41/War-and-peace_1873.gif', $feed->items[0]->getEnclosureUrl());
  #         $this->assertEquals('image/gif', $feed->items[0]->getEnclosureType());
  #         $parser = new Atom(file_get_contents('tests/fixtures/atom_empty_item.xml'));
  #         $feed = $parser->execute();
  #         $this->assertEquals('', $feed->items[0]->getEnclosureUrl());
  #         $this->assertEquals('', $feed->items[0]->getEnclosureType());
  # end

end
