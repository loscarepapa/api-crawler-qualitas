defmodule PolicyApi.Parser.Utils do
  def cast_digit_date(%Meeseeks.Result{} = el) do
    el
    |> Meeseeks.text()
    |> cast_digit_date()
  end

  def cast_digit_date(el) when is_binary(el) do
    case Regex.match?(~r/[0-9]{2}\/[0-9]{2}\/[0-9]{4}/, el) do
      true ->
        el
        |> String.split("/")
        |> (fn [d, m, y] -> "#{y}-#{m}-#{d}" end).()
        |> Date.from_iso8601!()
      false -> nil
    end
  end

  def cast_string_date(%Meeseeks.Result{} = el) do
    el
    |> Meeseeks.text()
    |> cast_string_date()
  end

  def cast_string_date(el) do
    case Regex.match?(~r/[0-9]{2}\/[A-Z]{3}\/[0-9]{4}/, el) do
      true ->
        el
        |> String.split("/")
        |> Enum.reverse()
        |> (fn [y, m, d] ->
          [y, month_to_digit(m), d]
        end).()
        |> Enum.join("-")
        |> Date.from_iso8601!()
      false -> nil
    end
  end

  def cast_range_date_to(%Meeseeks.Result{} = el) do
    text = el
    |> Meeseeks.text()

    cast_range_date(text, :to)
  end

  def cast_range_date(%Meeseeks.Result{} = el) do
    el
    |> Meeseeks.text()
    |> cast_range_date()
  end

  def cast_range_date(el, which \\ :from) do
    index = case which do
      :from -> 0
      :to -> 1
    end
    string_dates = ~r/[0-9]{2}\/[A-Z]{3}\/[0-9]{4}/
            |> Regex.scan(el)
            |> List.flatten()
    digit_dates = ~r/[0-9]{2}\/[0-9]{2}\/[0-9]{4}/
            |> Regex.scan(el)
            |> List.flatten()

    {fun, dates} = cond do
      length(string_dates) >= 1 -> {&cast_string_date/1, string_dates}
      length(digit_dates) >= 1 -> {&cast_digit_date/1, digit_dates}
      true -> {nil, []}
    end

    case length(dates) do
      2 ->
        dates
        |> Enum.at(index)
        |> fun.()
      1 ->
        dates
        |> Enum.at(0)
        |> fun.()
      _ -> nil
    end
  end

  def cast_percentage(%Meeseeks.Result{} = el) do
    el
    |> Meeseeks.text()
    |> cast_percentage()
  end

  def cast_percentage(el) when is_binary(el) do
    case Float.parse(el) do
      :error -> 0.0
      {n,_} -> n
    end
  end

  def cast_amount(%Meeseeks.Result{} = el) do
    el
    |> Meeseeks.text()
    |> cast_amount()
  end

  def cast_amount(el) when is_binary(el) do
    new_el = el
    |> String.replace([",", "$"], "")

    case Float.parse(new_el) do
      :error -> 0.0
      {n,_} -> n
    end
  end

  def cast_periodicity(%Meeseeks.Result{} = el) do
    el
    |> Meeseeks.text()
    |> cast_periodicity()
  end

  def cast_periodicity(el) when is_binary(el) do
    new_el = el
             |> String.split()
             |> Enum.at(0)

    periods = %{
      "MENSUAL" => "monthly",
      "TRIMESTRAL" => "quarterly",
      "SEMESTRAL" => "biannually",
      "CONTADO" => "yearly"
    }
    periods[new_el]
  end

  def cast_downpayment_days(%Meeseeks.Result{} = el) do
    el
    |> Meeseeks.text()
    |> cast_downpayment_days()
  end

  def cast_downpayment_days(el) when is_binary(el) do
    case Integer.parse(el) do
      :error -> 3
      {n,_} ->
        if n > 14 do
          3
        else
          n
        end
    end
  end

  defp month_to_digit(month) do
    months = %{
      "ENE" => "01",
      "FEB" => "02",
      "MAR" => "03",
      "ABR" => "04",
      "MAY" => "05",
      "JUN" => "06",
      "JUL" => "07",
      "AGO" => "08",
      "SEP" => "09",
      "OCT" => "10",
      "NOV" => "11",
      "DIC" => "12",
    }

    months[month]
  end
end
