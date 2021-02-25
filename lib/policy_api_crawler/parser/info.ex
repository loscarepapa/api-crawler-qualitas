defmodule PolicyApi.Parser.Info do
  alias PolicyApi.Parser.Utils
  import Meeseeks.CSS
  import Meeseeks.XPath

  @schema %{
    list: false,
    strategy: "css",
    selector: "html",
    props: [
      %{
        name: :number,
        strategy: "css",
        selector: "#policyNumber",
        func: &Meeseeks.text/1
      },
      %{
        name: :long_number,
        strategy: "xpath",
        selector: "//td[text() = 'Número de Póliza']/following-sibling::td/span/text()",
        func: &Meeseeks.text/1
      },
      %{
        name: :vehicle_description,
        strategy: "xpath",
        selector: "//td[text() = 'Descripción del Vehículo']/following-sibling::td/text()",
        func: &Meeseeks.text/1
      },
      %{
        name: :valid_from,
        strategy: "xpath",
        selector: "//th[text() = 'Vigencia']/ancestor::tr/following-sibling::tr/td/text()[1]",
        func: &Utils.cast_range_date/1
      },
      %{
        name: :valid_to,
        strategy: "xpath",
        selector: "//th[text() = 'Vigencia']/ancestor::tr/following-sibling::tr/td/text()[2]",
        func: &Utils.cast_range_date/1
      },
      %{
        name: :emitted_at,
        strategy: "xpath",
        selector: "//th[text() = 'Fecha de Emisión']/ancestor::tr/following-sibling::tr/td/text()",
        func: &Utils.cast_string_date/1
      },
      %{
        name: :downpayment_days,
        strategy: "xpath",
        selector: "//td[text() = 'Plazo de Pago']/following-sibling::td/text()",
        func: &Utils.cast_downpayment_days/1
      },
      %{
        name: :payment_periodicity,
        strategy: "css",
        selector: "#paymentType",
        func: &Meeseeks.text/1
      },
      %{
        name: :discount,
        strategy: "xpath",
        selector: "//th[text() = '% Desc.']/ancestor::tr/following-sibling::tr/td/text()",
        func: &Utils.cast_percentage/1
      },
      %{
        name: :net_premium,
        strategy: "xpath",
        selector: "//td[text() = 'Prima Neta']/following-sibling::td/text()",
        func: &Utils.cast_amount/1
      },
      %{
        name: :total_premium,
        strategy: "xpath",
        selector: "//td[text() = 'IMPORTE TOTAL']/following-sibling::td/text()",
        func: &Utils.cast_amount/1
      },
      %{
        name: :coverage_type,
        strategy: "css",
        selector: "#packageType",
        func: &Meeseeks.text/1
      }
    ]
  }

  def run(html) do
    doc = Meeseeks.parse(html)
         |> find_el_html(@schema)
         |> Meeseeks.parse()

    @schema.props
    |> Enum.map(fn prop ->
      val = find_el(doc, prop)
            |> prop.func.()
      {prop.name, val}
    end)
    |> Map.new
  end


  defp find_el_html(doc, props) do
    case find_el(doc, props) do
      nil -> ""
      el = %Meeseeks.Result{} -> Meeseeks.html(el)
    end
  end

  defp find_el(doc, %{strategy: "css"} = prop) do
    doc
    |> Meeseeks.one(css(prop.selector))
  end

  defp find_el(doc, %{strategy: "xpath"} = prop) do
    doc
    |> Meeseeks.one(xpath(prop.selector))
  end

  def cast_coverage_type(el) do
    case Meeseeks.text(el) do
      "AMPLIA" -> "broad"
      "LIMITADA" -> "limited"
      "RESPONSABILIDAD CIVIL" -> "civil_liability"
      _ -> "custom"
    end
  end
end
