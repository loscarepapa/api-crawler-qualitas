defmodule PolicyApi.Wallet.Policys do
  use Ecto.Schema
  import Ecto.Changeset

  schema "policy" do
    field :name, :string
    field :net_premium, :string
    field :number, :string
    field :payment_periodicity, :string
    field :status, :string
    field :telephone_1, :string
    field :total_premium, :string
    field :valid_from, :string
    field :valid_until, :string
    field :vehicle, :string

    timestamps()
  end

  @doc false
  def changeset(policys, attrs) do
    policys
    |> cast(attrs, [:number, :vehicle, :name, :net_premium, :total_premium, :valid_from, :valid_until, :payment_periodicity, :status, :telephone_1])
    |> validate_required([:number])
    |> unique_constraint(:number, number: :policy_number_index)
  end
end
