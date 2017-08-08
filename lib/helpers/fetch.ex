defmodule Feedex.Helpers.Fetch do
  @opts [
    # follow_redirect: true,
    timeout: 15_000,
    recv_timeout: 15_000
  ]

  def get(url) do
    case HTTPoison.get(url, [], @opts) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 301, headers: headers}} -> redirect(url, headers)
      {:ok, %HTTPoison.Response{status_code: 302, headers: headers}} -> redirect(url, headers)
      {:ok, %HTTPoison.Response{status_code: 307, headers: headers}} -> redirect(url, headers)

      _ -> {:error, :fetch_error}
    end
    # |> evaluate
  end

  # --

  defp redirect(url, headers) do
    location = headers
      |> Enum.into(%{}, fn ({key, value}) -> {String.downcase(key), value} end)
      |> Map.fetch!("location")

    if url == location do
      {:error, "redirect loop"}
    else
      get(location)
    end
  end

end
