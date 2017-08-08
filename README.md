# Feedex
[![Build Status](https://travis-ci.org/diegocurbelo/feedex.svg?branch=master)](https://travis-ci.org/diegocurbelo/feedex)
[![Hex.pm Version](http://img.shields.io/hexpm/v/feedex.svg?style=flat)](https://hex.pm/packages/feedex)

Elixir Feed Parser originally extracted from [reader.uy](https://reader.uy), a minimalist news reader.


## Installation

Add `feedex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:feedex, "~> 0.0.2"}]
end
```


## Usage

```elixir
> {:ok, feed} = Feedex.fetch_and_parse "http://9gagrss.com/feed/"
...

> {:ok, feed} = Feedex.parse "<rss version=\"2.0\" xmlns:content=\"http://purl.org/rss/1.0/modules/content/\" ..."
...

> feed.title
"9GAG RSS feed"

> feed.entries |> Enum.map(&(&1.title))
["Are you the lucky one ?", "Hide and Seek", "Playing guitar for little cate", ...]
```


## Documentation

Documentation is available at [https://hexdocs.pm/feedex](https://hexdocs.pm/feedex)


## License

This software is licensed under [the MIT license](LICENSE.md).


## Credits

This project was inspired by [Feedjira](http://feedjira.com/) and [PicoFeed](https://github.com/miniflux/picoFeed).