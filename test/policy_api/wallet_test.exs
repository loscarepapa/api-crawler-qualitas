defmodule PolicyApi.WalletTest do
  use PolicyApi.DataCase

  alias PolicyApi.Wallet

  describe "policy" do
    alias PolicyApi.Wallet.Policys

    @valid_attrs %{name: "some name", net_premium: "some net_premium", number: "some number", payment_periodicity: "some payment_periodicity", status: "some status", telephone_1: "some telephone_1", total_premium: "some total_premium", valid_from: "some valid_from", valid_until: "some valid_until", vehicle: "some vehicle"}
    @update_attrs %{name: "some updated name", net_premium: "some updated net_premium", number: "some updated number", payment_periodicity: "some updated payment_periodicity", status: "some updated status", telephone_1: "some updated telephone_1", total_premium: "some updated total_premium", valid_from: "some updated valid_from", valid_until: "some updated valid_until", vehicle: "some updated vehicle"}
    @invalid_attrs %{name: nil, net_premium: nil, number: nil, payment_periodicity: nil, status: nil, telephone_1: nil, total_premium: nil, valid_from: nil, valid_until: nil, vehicle: nil}

    def policys_fixture(attrs \\ %{}) do
      {:ok, policys} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wallet.create_policys()

      policys
    end

    test "list_policy/0 returns all policy" do
      policys = policys_fixture()
      assert Wallet.list_policy() == [policys]
    end

    test "get_policys!/1 returns the policys with given id" do
      policys = policys_fixture()
      assert Wallet.get_policys!(policys.id) == policys
    end

    test "create_policys/1 with valid data creates a policys" do
      assert {:ok, %Policys{} = policys} = Wallet.create_policys(@valid_attrs)
      assert policys.name == "some name"
      assert policys.net_premium == "some net_premium"
      assert policys.number == "some number"
      assert policys.payment_periodicity == "some payment_periodicity"
      assert policys.status == "some status"
      assert policys.telephone_1 == "some telephone_1"
      assert policys.total_premium == "some total_premium"
      assert policys.valid_from == "some valid_from"
      assert policys.valid_until == "some valid_until"
      assert policys.vehicle == "some vehicle"
    end

    test "create_policys/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallet.create_policys(@invalid_attrs)
    end

    test "update_policys/2 with valid data updates the policys" do
      policys = policys_fixture()
      assert {:ok, %Policys{} = policys} = Wallet.update_policys(policys, @update_attrs)
      assert policys.name == "some updated name"
      assert policys.net_premium == "some updated net_premium"
      assert policys.number == "some updated number"
      assert policys.payment_periodicity == "some updated payment_periodicity"
      assert policys.status == "some updated status"
      assert policys.telephone_1 == "some updated telephone_1"
      assert policys.total_premium == "some updated total_premium"
      assert policys.valid_from == "some updated valid_from"
      assert policys.valid_until == "some updated valid_until"
      assert policys.vehicle == "some updated vehicle"
    end

    test "update_policys/2 with invalid data returns error changeset" do
      policys = policys_fixture()
      assert {:error, %Ecto.Changeset{}} = Wallet.update_policys(policys, @invalid_attrs)
      assert policys == Wallet.get_policys!(policys.id)
    end

    test "delete_policys/1 deletes the policys" do
      policys = policys_fixture()
      assert {:ok, %Policys{}} = Wallet.delete_policys(policys)
      assert_raise Ecto.NoResultsError, fn -> Wallet.get_policys!(policys.id) end
    end

    test "change_policys/1 returns a policys changeset" do
      policys = policys_fixture()
      assert %Ecto.Changeset{} = Wallet.change_policys(policys)
    end
  end
end
