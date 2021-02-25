 defmodule PolicyApi.Parser.Customer do
  import Meeseeks.CSS
  import Meeseeks.XPath

  @schema %{
    list: false,
    strategy: "css",
    selector: "#portlet-container",
    props: [
      %{
        name: :id,
        strategy: "css",
        selector: "#asegNumber",
        func: &Meeseeks.text/1
      },
      %{
        name: :tax_registration_id,
        strategy: "css",
        selector: "#rfc",
        func: &Meeseeks.text/1
      },
      %{
        name: :full_name,
        strategy: "css",
        selector: "#asegName",
        func: &Meeseeks.text/1
      },
      %{
        name: :address,
        strategy: "css",
        selector: "#address",
        func: &Meeseeks.text/1
      },
      %{
        name: :telephone,
        strategy: "css",
        selector: "#telephone",
        func: &Meeseeks.text/1
      },
      %{
        name: :email,
        strategy: "css",
        selector: "#email0",
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
end
