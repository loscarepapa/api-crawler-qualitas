defmodule PolicyApi.Parser.ComputedProperties do
  def run(policy) do
    p = next_payment(policy.receipts)

    %{
      status: status(policy),
      payment_status: payment_status(policy),
      days_until_next_payment: days_to_pay(policy),
      to_collect: amount_to_collect(policy),
      collected: amount_collected(policy),
      percentage_collected: percentage_collected(policy),
      next_receipt_number: p[:number],
      next_receipt_pay_before: p[:pay_before],
      next_receipt_total: p[:total],
      next_receipt_paid_at: p[:paid_at],
      next_receipt_status: p[:status]
    }
  end

  defp status(policy) do
    cond do
      no_payments?(policy) && !first_payment_expired?(policy) -> "EMITIDA PAGO PENDIENTE"
      no_payments?(policy) && first_payment_expired?(policy) -> "EMITIDA CANCELADA"
      totally_paid?(policy) && (days_to_finish(policy) <= 30) && (days_to_finish(policy) >= -30) -> "POR RENOVAR"
      totally_paid?(policy) && valid?(policy) -> "VIGENTE"
      totally_paid?(policy) && !valid?(policy) -> "FINALIZADA"
      partially_paid?(policy) && !payment_expired?(policy) -> "VIGENTE"
      partially_paid?(policy) && (days_to_pay(policy) > -30) -> "POR RECUPERAR (CANCELACION < 30 DIAS)"
      partially_paid?(policy) && (days_to_pay(policy) < -30) -> "CANCELADA (CANCELACION > 30 DIAS)"
      :true -> "Error" 
    end
  end

  defp no_payments?(policy) do
    count = policy.receipts
            |> receipts_by_status(:paid)
            |> length()

    count == 0
  end

  defp first_payment_expired?(policy) do
    receipt = policy.receipts
              |> Enum.sort(fn a, b ->
                Date.compare(a.pay_before, b.pay_before) == :lt
              end)
              |> Enum.at(0)
    pay_before = Date.add(receipt.pay_before, policy.downpayment_days)
    date_compare = Date.compare(pay_before, Date.utc_today)

    cond do
      receipt.status == "PAGADO" -> false
      (date_compare == :lt) || (date_compare == :eq) -> true
      true -> false
    end
  end

  defp payment_expired?(policy) do
    days_to_pay(policy) <= 0
  end

  defp days_to_finish(policy) do
    Date.diff(policy.valid_to, Date.utc_today)
  end

  defp days_to_pay(policy) do
    p = next_payment(policy.receipts)
    Date.diff(p.pay_before, Date.utc_today)
  end

  defp totally_paid?(policy) do
    amount_to_collect(policy) == 0.0
  end

  defp partially_paid?(policy) do
    (amount_collected(policy) > 0.0) && !totally_paid?(policy)
  end

  defp valid?(policy) do
    Date.compare(policy.valid_to, Date.utc_today()) == :gt
  end

  defp receipts_by_status(receipts, status) do
    text_status = case status do
      :paid -> "PAGADO"
      :expired -> "VENCIDO"
      :pending -> "PENDIENTE"
    end

    receipts
    |> Enum.filter(fn r ->
      String.contains?(r.status, text_status)
    end)
  end

  defp payment_status(policy) do
    cond do
      totally_paid?(policy) -> "PAGO TOTAL"
      partially_paid?(policy) -> "PAGO PARCIAL"
      days_to_pay(policy) < 10 && !payment_expired?(policy) -> "POR COBRAR"
      payment_expired?(policy) -> "VENCIDO"
      days_to_pay(policy) <= -30 -> "CANCELADO"
      :true -> "Error"
    end
  end

  defp percentage_collected(policy) do
    (amount_collected(policy) * 100) / policy.total_premium
  end

  defp amount_collected(policy) do
    policy.receipts
    |> receipts_by_status(:paid)
    |> Enum.reduce(0, fn r, acc -> r.total + acc end)
  end

  defp amount_to_collect(policy) do
    policy.total_premium - amount_collected(policy)
  end

  defp next_payment(receipts) do
    next = receipts
           |> Enum.filter(fn el ->
             el.status != "PAGADO" && !!el.pay_before && el.total > 0
           end)
           |> Enum.sort(fn a, b ->
             Date.compare(a.pay_before, b.pay_before) == :lt
           end)
           |> Enum.at(0)
    case next do
      %{} = next -> next
      _ ->
        %{pay_before: ~D[1993-01-01]}
    end
  end
end
