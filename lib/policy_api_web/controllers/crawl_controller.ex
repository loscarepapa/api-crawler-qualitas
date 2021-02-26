defmodule PolicyApiWeb.CrawlController do
  use PolicyApiWeb, :controller

  alias PolicyApi.Wallet
  alias PolicyApi.Crawl
  alias PolicyApi.Parser.To

  action_fallback PolicyApiWeb.FallbackController

  def index(conn, %{"credentials" => %{"key" => key, "count" => count, "password" => password}, "policy" => number}) do

    dates = case Wallet.get_by_number(number) do
      {:ok, dates} -> 
        Task.async(fn -> 
          Crawl.run([key, count, password], number) 
          |> Wallet.create_policys()
        end)

        dates
      {:error, :not_found} -> Crawl.run([key, count, password], number) |> Wallet.create_policys()
    end

    conn
    |> json(%{dates: "hola"})
  end

  def index(conn, _params) do
    conn
    |> json(%{error: "invalid_params"})
  end

end
