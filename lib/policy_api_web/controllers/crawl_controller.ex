defmodule PolicyApiWeb.CrawlController do
  use PolicyApiWeb, :controller
  alias PolicyApi.Wallet
  alias PolicyApi.Crawl

  action_fallback PolicyApiWeb.FallbackController

  def create(conn, %{"credentials" => %{"key" => key, "count" => count, "password" => password}, "policy" => policy}) do

    dates = case Wallet.get_by_number(policy) do
      {:ok, dates} -> dates 
      {:error, :not_found} -> 
         res = Wallet.create_policys(%{number: policy})
        {_status, database_policy} = res
        Task.async(fn ->
          try do
            crawl_policy = Crawl.run([key, count, password], policy) 
                           |> Map.put(:sync_status, "done")
            Wallet.update_policys(database_policy, crawl_policy)
          rescue
            _e in RuntimeError ->  
              Wallet.update_policys(database_policy, %{sync_status: "fail"})
          end
        end)
        database_policy
    end

    conn
    |> json(dates)
  end

  def create(conn, _params) do
    conn
    |> json(%{error: "invalid_params"})
  end

  def show(conn, %{"id" => id}) do
    res = case Wallet.get_by_id(id) do
      {:ok, policy} ->  policy
      {:error, _} -> %{error: "not found"} 
    end
    conn
    |> json(res)
  end

  def show(conn, %{"number" => number}) do
    res = case Wallet.get_by_number(number) do
      {:ok, policy} ->  policy
      {:error, _} -> %{error: "not found"} 
    end
    conn
    |> json(res)
  end

  def show(conn, _params) do
    res = Wallet.list_policy()
    conn
    |> json(res)
  end

end
