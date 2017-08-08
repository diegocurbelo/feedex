defmodule Feedex.Helpers.Xml do
  @moduledoc """
    A wrapper for erlang's xmerl xml parser.
  """

  def preprocess(xml, opts \\ [quiet: true]) do
    try do
      {doc, _} = :binary.bin_to_list(xml) |> :xmerl_scan.string(opts)
      {:ok, doc}
    catch
      :exit, _ -> {:error, :invalid_xml}
    end
  end

  def find(node, path) do
    xpath(node, path)
  end

  def first(node, path) do
    xpath(node, path) |> List.first
  end

  def text(node) do
    xpath(node, "./text()") |> extract_text
  end

  def attr(node, name) do
    xpath(node, "./@#{name}") |> extract_attr
  end

  def date(node) do
    text(node)
    |> fix_date
    |> parse_date
  end

  # --

  defp xpath(nil, _), do: nil
  defp xpath(node, path) do
    to_char_list(path) |> :xmerl_xpath.string(node)
  end

  defp extract_text([head | tail]), do: "#{extract_text(head)}#{extract_text(tail)}"
  defp extract_text({:xmlText, _, _, _, value, _}), do: List.to_string(value)
  defp extract_text(_), do: nil

  defp extract_attr([{:xmlAttribute, _, _, _, _, _, _, _, value, _}]), do: List.to_string(value)
  defp extract_attr(_), do: nil

  @date_patterns [
    "{ISO:Extended}", "{ISO:Extended:Z}", "{ISO:Basic}", "{ISO:Basic:Z}",
    "{RFC1123}", "{RFC1123z}", "{RFC3339}", "{RFC3339z}",
    "{ANSIC}", "{UNIX}", "{RFC822}", "{RFC822z}"
  ]
  def parse_date(str, patterns \\ @date_patterns)
  def parse_date(str, [pattern | patterns]) do
    case Timex.parse(str, pattern) do
      {:ok, date} -> Timex.Timezone.convert(date, "GMT")
      _           -> parse_date(str, patterns)
    end
  end
  def parse_date(_, _), do: nil

  # --

  @spec fix_date(String.t) :: String.t
  defp fix_date(str) when is_binary(str), do: String.replace(str, ~r/GMT/u, "")
  defp fix_date(_), do: nil

  @doc """
    Remove all occurences of javascript using a regex.
  """
  @spec without_js(String.t) :: String.t
  def without_js(text) do
    rx = ~r/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/i
    String.replace(text, rx, "")
  end
end
