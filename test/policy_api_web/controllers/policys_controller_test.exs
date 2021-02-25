defmodule PolicyApiWeb.PolicysControllerTest do
  use PolicyApiWeb.ConnCase

  alias PolicyApi.Wallet
  alias PolicyApi.Wallet.Policys

  @create_attrs %{
    name: "some name",
    net_premium: "some net_premium",
    number: "some number",
    payment_periodicity: "some payment_periodicity",
    status: "some status",
    telephone_1: "some telephone_1",
    total_premium: "some total_premium",
    valid_from: "some valid_from",
    valid_until: "some valid_until",
    vehicle: "some vehicle"
  }
  @update_attrs %{
    name: "some updated name",
    net_premium: "some updated net_premium",
    number: "some updated number",
    payment_periodicity: "some updated payment_periodicity",
    status: "some updated status",
    telephone_1: "some updated telephone_1",
    total_premium: "some updated total_premium",
    valid_from: "some updated valid_from",
    valid_until: "some updated valid_until",
    vehicle: "some updated vehicle"
  }
  @invalid_attrs %{name: nil, net_premium: nil, number: nil, payment_periodicity: nil, status: nil, telephone_1: nil, total_premium: nil, valid_from: nil, valid_until: nil, vehicle: nil}

  def fixture(:policys) do
    {:ok, policys} = Wallet.create_policys(@create_attrs)
    policys
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all policy", %{conn: conn} do
      conn = get(conn, Routes.policys_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create policys" do
    test "renders policys when data is valid", %{conn: conn} do
      conn = post(conn, Routes.policys_path(conn, :create), policys: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.policys_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "net_premium" => "some net_premium",
               "number" => "some number",
               "payment_periodicity" => "some payment_periodicity",
               "status" => "some status",
               "telephone_1" => "some telephone_1",
               "total_premium" => "some total_premium",
               "valid_from" => "some valid_from",
               "valid_until" => "some valid_until",
               "vehicle" => "some vehicle"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.policys_path(conn, :create), policys: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update policys" do
    setup [:create_policys]

    test "renders policys when data is valid", %{conn: conn, policys: %Policys{id: id} = policys} do
      conn = put(conn, Routes.policys_path(conn, :update, policys), policys: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.policys_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "net_premium" => "some updated net_premium",
               "number" => "some updated number",
               "payment_periodicity" => "some updated payment_periodicity",
               "status" => "some updated status",
               "telephone_1" => "some updated telephone_1",
               "total_premium" => "some updated total_premium",
               "valid_from" => "some updated valid_from",
               "valid_until" => "some updated valid_until",
               "vehicle" => "some updated vehicle"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, policys: policys} do
      conn = put(conn, Routes.policys_path(conn, :update, policys), policys: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete policys" do
    setup [:create_policys]

    test "deletes chosen policys", %{conn: conn, policys: policys} do
      conn = delete(conn, Routes.policys_path(conn, :delete, policys))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.policys_path(conn, :show, policys))
      end
    end
  end

  defp create_policys(_) do
    policys = fixture(:policys)
    %{policys: policys}
  end
end
