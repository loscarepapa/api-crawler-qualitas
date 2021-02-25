Application.start :hound

defmodule PolicyApi.Crawl do

  use Hound.Helpers
  alias PolicyApi.Utils, as: H
  alias PolicyApi.Parser.Customer
  alias PolicyApi.Parser.Info
  alias PolicyApi.Parser.ComputedProperties
  alias PolicyApi.Parser.Receipts

  def run(credentials, number) do
    with {:ok, valid_num} <- valid_number(number),
         {:ok, _message} <- login(credentials) do
      dates = get_dates(valid_num)
              |> parse_policy()
      dates
    end

  end

  defp valid_number(number) do
    val = String.length(number)
    cond do
      val == 10 ->  {:ok, number}
      :true ->  {:error, number}
    end
  end

  defp login([key, count, pass] = _credentials) do
    try do
      Hound.start_session
      navigate_to("https://agentes.qualitas.com.mx/cas/login?service=https%3A%2F%2Fagentes.qualitas.com.mx%2Fc%2Fportal%2Flogin")
      fill_field(find_element(:name, "agente"), "#{key}")
      fill_field(find_element(:name, "username"), "#{count}")
      fill_field(find_element(:name, "password"), "#{pass}")
      find_element(:name, "submit") |> click() 
      {:ok, "credentials valids"}
    rescue
      _e in RuntimeError ->  {:error, "credentials invalids"}
    end
  end

  defp get_dates(number) do
    H.visit_and_wait_for("https://agentes.qualitas.com.mx/group/guest/escritorio-360", :class, "tabAdmin")

    funs = [
      "showConsultaPoliza('#{number}');",
      "showAvisoCobranza('#{number}');"
    ]

    funs
    |> Enum.join(" ")
    |> execute_script()

    info_html = crawl_fragment(
      %{
        modal: "dialogConsultaPoliza",
        iframe: "ifrConsultaPoliza"
      },
      ["data-policy", "data-receipts", "status-policy"]
    )

    customer_html = crawl_fragment(
      %{
        modal: "dialogAvisoCobranza",
        iframe: "ifrAvisoCobranza"
      },
      ["portlet-container"]
    )

    info_html <> customer_html

  end

  defp parse_policy(html) do
    info = Info.run(html)
    customer = %{customer: Customer.run(html)}
    receipts = %{receipts: Receipts.run(html)}

    raw_policy = info
                 |> Map.merge(customer)
                 |> Map.merge(receipts)

    props = raw_policy |> ComputedProperties.run()
    Map.merge(raw_policy, props)
  end

  defp crawl_fragment(selectors, fragments) do
    H.wait_for(:id, selectors.modal, 50)

    iframe = find_element(:id, selectors.iframe)
    focus_frame(iframe)

    html = fragments
           |> Enum.map(&extract_fragment/1)
           |> Enum.join(" ")

    focus_parent_frame()
    html
  end

  defp extract_fragment(id) do
    try do
      H.wait_for(:id, id, 50)

      find_element(:id, id)
      |> outer_html()
    rescue
      _ -> ""
    end
  end

end
