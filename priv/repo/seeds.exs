alias PolicyApi.Repo
alias PolicyApi.Wallet.Policys

Repo.insert! %Policys{
  address: "HIDALGO PBO SANTIAGO TEYAHUALCO TULTEPEC ESTADO DE MEXICO 54980",
  collected: 4404.299999999999,
  coverage_type: "LIMITADA",
  days_until_next_payment: 6,
  discount: 20.0,
  downpayment_days: 14,
  email: "",
  emitted_at: ~D[2021-01-04],
  full_name: "MOISES FERNANDEZ CORTES",
  id_customer: "0020544281",
  long_number: "040003886456000000",
  net_premium: 18590.79,
  next_receipt_number: "0182802865",
  next_receipt_paid_at: nil,
  next_receipt_pay_before: ~D[2021-03-04],
  next_receipt_status: "PENDIENTE",
  next_receipt_total: 1912.12,
  number: "0003886456",
  payment_periodicity: "MENSUAL",
  payment_status: "PAGO PARCIAL",
  percentage_collected: 18.721387430660346,
  status: "VIGENTE",
  tax_registration_id: "FECM881111DV3",
  telephone: "5532365972",
  to_collect: 19121.2,
  total_premium: 23525.5,
  valid_from: ~D[2021-01-04],
  valid_to: ~D[2022-01-04],
  vehicle_description: "()TR VOLVO VNL 64T 420 STD. MODELO 2001",
  sync_status: "done"
}

Repo.insert! %Policys{
  address: "HIDALGO PBO SANTIAGO TEYAHUALCO TULTEPEC ESTADO DE MEXICO 54980",
  collected: 4404.299999999999,
  coverage_type: "LIMITADA",
  days_until_next_payment: 6,
  discount: 20.0,
  downpayment_days: 14,
  email: "",
  emitted_at: ~D[2021-01-04],
  full_name: "MOISES FERNANDEZ CORTES",
  id_customer: "0020544281",
  long_number: "040003886456000000",
  net_premium: 18590.79,
  next_receipt_number: "0182802865",
  next_receipt_paid_at: nil,
  next_receipt_pay_before: ~D[2021-03-04],
  next_receipt_status: "PENDIENTE",
  next_receipt_total: 1912.12,
  number: "0003888956",
  payment_periodicity: "MENSUAL",
  payment_status: "PAGO PARCIAL",
  percentage_collected: 18.721387430660346,
  status: "VIGENTE",
  tax_registration_id: "FECM881111DV3",
  telephone: "5532365972",
  to_collect: 19121.2,
  total_premium: 23525.5,
  valid_from: ~D[2021-01-04],
  valid_to: ~D[2022-01-04],
  vehicle_description: "()TR VOLVO VNL 64T 420 STD. MODELO 2001",
  sync_status: "done"
}

Repo.insert! %Policys{
  address: "HIDALGO PBO SANTIAGO TEYAHUALCO TULTEPEC ESTADO DE MEXICO 54980",
  collected: 4404.299999999999,
  coverage_type: "LIMITADA",
  days_until_next_payment: 6,
  discount: 20.0,
  downpayment_days: 14,
  email: "",
  emitted_at: ~D[2021-01-04],
  full_name: "MOISES FERNANDEZ CORTES",
  id_customer: "0020544281",
  long_number: "040003886456000000",
  net_premium: 18590.79,
  next_receipt_number: "0182802865",
  next_receipt_paid_at: nil,
  next_receipt_pay_before: ~D[2021-03-04],
  next_receipt_status: "PENDIENTE",
  next_receipt_total: 1912.12,
  number: "0003676456",
  payment_periodicity: "MENSUAL",
  payment_status: "PAGO PARCIAL",
  percentage_collected: 18.721387430660346,
  status: "VIGENTE",
  tax_registration_id: "FECM881111DV3",
  telephone: "5532365972",
  to_collect: 19121.2,
  total_premium: 23525.5,
  valid_from: ~D[2021-01-04],
  valid_to: ~D[2022-01-04],
  vehicle_description: "()TR VOLVO VNL 64T 420 STD. MODELO 2001",
  sync_status: "done"
}


# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PolicyApi.Repo.insert!(%PolicyApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
