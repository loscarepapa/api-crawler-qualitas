defmodule PolicyApi.Utils do
  use Hound.Helpers

  def visit_and_wait_for(url, strategy, selector) do
    navigate_to(url)
    wait_for(strategy, selector)
  end

  def wait_for(strategy, selector, retries \\ 5)

  def wait_for(_, _, retries) when retries == 0, do: false

  def wait_for(strategy, selector, retries) do
    :timer.sleep(100)
    case search_el(strategy, selector) do
      {:ok, _} -> true
      {:error, _} -> wait_for(strategy, selector, retries - 1)
    end
  end

  defp search_el(:text, sel) do
    found = visible_page_text() |> String.contains?(sel)
    case found do
      true -> {:ok, "FOUND"}
      false -> {:error, "NOT_FOUND"}
    end
  end

  defp search_el(strategy, sel) do
    search_element(strategy, sel)
  end
end
