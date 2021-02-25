defmodule PolicyApiWeb.CrawlController do
  use PolicyApiWeb, :controller

  alias PolicyApi.Wallet
  alias PolicyApi.Wallet.Policys
  alias PolicyApi.Crawl

  action_fallback PolicyApiWeb.FallbackController

  def index(conn, %{"credentials" => %{"key" => key, "count" => count, "password" => password}, "policy" => number}) do
    dates = Crawl.run([key, count, password], number)
    conn
    |> json(%{dates: dates})
  end

  def index(conn, _params) do
    conn
    |> json(%{error: "invalid_params"})
  end

end
