defmodule PolicyApi.Repo.Migrations.CreatePolicy do
  use Ecto.Migration

  def change do
    create table(:policy) do
      add :number, :string
      add :vehicle, :string
      add :name, :string
      add :net_premium, :string
      add :total_premium, :string
      add :valid_from, :string
      add :valid_until, :string
      add :payment_periodicity, :string
      add :status, :string
      add :telephone_1, :string

      unique_index(:policy, [:number])

      timestamps()
    end
    create unique_index(:policy, [:number])
  end
end
