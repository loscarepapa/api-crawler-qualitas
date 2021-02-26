defmodule PolicyApi.Wallet.Policys do
  use Ecto.Schema
  import Ecto.Changeset

  schema "policy" do
    field :address, :string, default: nil
    field :collected, :float, default: nil
    field :coverage_type, :string, default: nil
    field :days_until_next_payment, :integer, default: nil
    field :discount, :float, default: nil, default: nil
    field :downpayment_days, :integer, default: nil
    field :email, :string, default: nil
    field :id_customer, :string, default: nil
    field :emitted_at, :date, default: nil
    field :full_name, :string, default: nil
    field :long_number, :string, default: nil
    field :net_premium, :float, default: nil
    field :next_receipt_number, :string, default: nil
    field :next_receipt_paid_at, :string, default: nil
    field :next_receipt_pay_before, :date, default: nil
    field :next_receipt_status, :string, default: nil
    field :next_receipt_total, :float, default: nil
    field :number, :string
    field :payment_periodicity, :string, default: nil
    field :payment_status, :string, default: nil
    field :percentage_collected, :float, default: nil
    field :status, :string, default: nil
    field :tax_registration_id, :string, default: nil
    field :telephone, :string, default: nil
    field :to_collect, :float, default: nil
    field :total_premium, :float, default: nil
    field :valid_from, :date, default: nil
    field :valid_to, :date, default: nil
    field :vehicle_description, :string, default: nil
    field :sync_status, :string, default: "processing" 

    timestamps()
  end

  @doc false
  def changeset(policys, attrs) do
    policys
    |> cast(attrs, 
      [:address,
        :collected,
        :coverage_type,
        :days_until_next_payment,
        :discount,
        :downpayment_days,
        :email,
        :id_customer,
        :emitted_at,
        :full_name,
        :long_number,
        :net_premium,
        :next_receipt_number,
        :next_receipt_paid_at,
        :next_receipt_pay_before,
        :next_receipt_status,
        :next_receipt_total, 
        :number, 
        :payment_periodicity, 
        :payment_status,
        :percentage_collected,
        :status,
        :tax_registration_id,
        :telephone,
        :to_collect,
        :total_premium,
        :valid_from,
        :valid_to,
        :vehicle_description,
        :sync_status])
        |> validate_required([:number])
        |> unique_constraint(:number, number: :policy_number_index)
  end
end
