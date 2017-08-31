defmodule Feedex.Helpers.Sanitizer do
  @moduledoc false
  
  alias HtmlSanitizeEx.Scrubber
  alias Feedex.Helpers.Sanitizers.HTML

  def basic_html(html) do
    html |> Scrubber.scrub(HTML)
  end

end
