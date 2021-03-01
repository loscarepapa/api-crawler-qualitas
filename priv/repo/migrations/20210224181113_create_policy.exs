defmodule PolicyApi.Repo.Migrations.CreatePolicy do
  use Ecto.Migration

  def change do
    create table(:policy) do
      add :address, :string
      add :collected, :float
      add :coverage_type, :string 
      add :days_until_next_payment, :integer 
      add :discount, :float 
      add :downpayment_days, :integer
      add :email, :string 
      add :id_customer, :string 
      add :emitted_at, :date
      add :full_name, :string
      add :long_number, :string
      add :net_premium, :float 
      add :next_receipt_number, :string
      add :next_receipt_paid_at, :string
      add :next_receipt_pay_before, :date
      add :next_receipt_status, :string 
      add :next_receipt_total, :float 
      add :number, :string 
      add :payment_periodicity, :string 
      add :payment_status, :string 
      add :percentage_collected, :float 
      add :status, :string 
      add :tax_registration_id, :string 
      add :telephone, :string 
      add :to_collect, :float 
      add :total_premium, :float 
      add :valid_from, :date 
      add :valid_to, :date 
      add :vehicle_description, :string
      add :sync_status, :string
      add :pdf, :bytea 

      unique_index(:policy, [:number])

      timestamps()
    end
    create unique_index(:policy, [:number])
  end
end
