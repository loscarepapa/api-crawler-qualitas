defmodule PolicyApi.Parser.Receipts do
  import Meeseeks.CSS
  import Meeseeks.XPath
  alias PolicyApi.Parser.Utils

  @schema %{
    list: true,
    strategy: "xpath",
    selector: "//*[@id='status-policy']//table[@class='tab-summary']//tr[position() > 1][count(./td) = 7]",
    props: [
      %{
        name: :number,
        strategy: "xpath",
        selector: "//table//td[4]",
        func: &Meeseeks.text/1
      },
      %{
        name: :pay_before,
        strategy: "xpath",
        selector: "//table//td[2]",
        func: &Utils.cast_digit_date/1
      },
      %{
        name: :total,
        strategy: "xpath",
        selector: "//table//td[3]",
        func: &Utils.cast_amount/1
      },
      %{
        name: :paid_at,
        strategy: "xpath",
        selector: "//table//td[6]",
        func: &Utils.cast_range_date/1
      },
      %{
        name: :status,
        strategy: "xpath",
        selector: "//table//td[7]",
        func: &Meeseeks.text/1
      }
    ]
  }

  def run(html) do
    receipts_rows = Meeseeks.parse(html)
                    |> Meeseeks.all(xpath(@schema.selector))
                    |> Enum.map(fn row ->
                      row
                      |> (fn el -> "<table>" <> Meeseeks.html(el) <> "</table>" end).()
                      |> Meeseeks.parse()
                    end)


    receipts_rows
    |> Enum.map(fn current_doc ->
      @schema.props
      |> Enum.map(fn prop ->
        val = find_el(current_doc, prop)
              |> prop.func.()
        {prop.name, val}
      end)
      |> Map.new
    end)
    |> Enum.filter(fn r ->
      !!r.pay_before && r.total > 0
    end)
  end

  defp find_el(doc, %{strategy: "css"} = prop) do
    doc
    |> Meeseeks.one(css(prop.selector))
  end

  defp find_el(doc, %{strategy: "xpath"} = prop) do
    doc
    |> Meeseeks.one(xpath(prop.selector))
  end
end
