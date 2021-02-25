defmodule PolicyApiWeb.CrawlController do
  use PolicyApiWeb, :controller

  alias PolicyApi.Wallet
  alias PolicyApi.Wallet.Policys
  alias PolicyApi.Crawl

  action_fallback PolicyApiWeb.FallbackController

  def index(conn, %{"credentials" => %{"key" => key, "count" => count, "password" => password}, "policy" => number}) do
    Crawl.run([key, count, password], number)
    json(conn, %{credentials: %{key: key, count: count, password: password}, policy: number})
  end

  def index(conn, _params) do
    text conn, "hola" 
  end

  def create(conn, %{"policys" => policys_params}) do
    with {:ok, %Policys{} = policys} <- Wallet.create_policys(policys_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.policys_path(conn, :show, policys))
      |> render("show.json", policys: policys)
    end
  end

  def show(conn, %{"id" => id}) do
    policys = Wallet.get_policys!(id)
    render(conn, "show.json", policys: policys)
  end

  def update(conn, %{"id" => id, "policys" => policys_params}) do
    policys = Wallet.get_policys!(id)

    with {:ok, %Policys{} = policys} <- Wallet.update_policys(policys, policys_params) do
      render(conn, "show.json", policys: policys)
    end
  end

  def delete(conn, %{"id" => id}) do
    policys = Wallet.get_policys!(id)

    with {:ok, %Policys{}} <- Wallet.delete_policys(policys) do
      send_resp(conn, :no_content, "")
    end
  end
end
