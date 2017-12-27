# Feedex
[![Build Status](https://travis-ci.org/diegocurbelo/feedex.svg?branch=master)](https://travis-ci.org/diegocurbelo/feedex)
[![Hex.pm Version](http://img.shields.io/hexpm/v/feedex.svg?style=flat)](https://hex.pm/packages/feedex)

Elixir Feed Parser originally extracted from [reader.uy](https://reader.uy), a minimalist news reader.


## Installation

Add `feedex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:feedex, "~> 0.1"}]
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


## Results

#### Feed
  - `id` feed identifier (usually the site url)
  - `title` feed title
  - `description` feed description
  - `url` feed url
  - `site_url` feed main site url
  - `updated` feed last modification timestamp
  - `entries` entry list

#### Entry
  - `id` unique identifier (SHA256)
  - `title` entry title
  - `url` entry permalink
  - `content` entry content
  - `updated` entry publication or modification timestamp


## Documentation

Documentation is available at [https://hexdocs.pm/feedex](https://hexdocs.pm/feedex)


## License

This software is licensed under [the MIT license](LICENSE.md).


## Credits

This project was inspired by [Feedjira](http://feedjira.com/) and [PicoFeed](https://github.com/miniflux/picoFeed).
