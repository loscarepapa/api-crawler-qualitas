defmodule PolicyApi.Crawl do
  use Hound.Helpers
  alias PolicyApi.Utils, as: H
  alias PolicyApi.Parser.Customer
  alias PolicyApi.Parser.Info
  alias PolicyApi.Parser.ComputedProperties
  alias PolicyApi.Parser.Receipts

  @notFound %{id: "messageDialog"}

  def run(credentials, number) do
    start_hound()

    login? = case valid_number(number) do
      {:ok, _valid_num} -> login(credentials) 
      {:error, _valid_num} -> %{error: "invalid number"}
    end

    policy? = case login? do
      {:ok, _} -> policy_exist(number)
      %{error: "invalid number"} -> %{error: "invalid number"}
      {:error, _} -> %{error: "credentials wrongs"}
    end

    dates = case policy? do
      {:ok, _} -> get_dates() |> parse_policy()
      %{error: "invalid number"} -> %{error: "invalid number"}
      {:error, "NO_EXIST_POLICY"} -> %{error: "policy no exist"}
      %{error: "credentials wrongs"} -> %{error: "credentials wrongs"}
      %{error: _} -> %{error: "policy no exist"}
    end
    dates
  end

  def valid_number(number) do
    val = String.length(number)
    cond do
      val == 10 ->  {:ok, number}
      :true ->  {:error, number}
    end
  end

  def start_hound() do
    try do
      Hound.start_session
    rescue
      _e in RuntimeError -> 
        Hound.end_session
        start_hound() 
    end
  end

  def login([key, count, pass] = _credentials) do
    try do
      navigate_to("https://agentes.qualitas.com.mx/cas/login?service=https%3A%2F%2Fagentes.qualitas.com.mx%2Fc%2Fportal%2Flogin")
      fill_field(find_element(:name, "agente"), "#{key}")
      fill_field(find_element(:name, "username"), "#{count}")
      fill_field(find_element(:name, "password"), "#{pass}")
      find_element(:name, "submit") |> click() 
      found = visible_page_text() |> String.contains?("INFORMACIÓN")
      if found do
        {:ok, "credentials valids"}
      else
        {:error, "credentials invalids"}
      end
    rescue
      _e in RuntimeError ->  {:error, "credentials invalids"}
    end
  end

  defp policy_exist(number) do
    navigate_to("https://agentes.qualitas.com.mx/group/guest/escritorio-360")

    funs = [
      "showConsultaPoliza('#{number}');",
      "showAvisoCobranza('#{number}');"
    ]

    funs
    |> Enum.join(" ")
    |> execute_script()

    H.wait_for(:id, "dialogAvisoCobranza", 50)

    iframe = find_element(:id, "ifrAvisoCobranza")
    focus_frame(iframe)

    text = find_element(:id, @notFound.id)
           |> inner_text()

    focus_parent_frame()
    cond do
      text =~ "NO VALIDA PARA EL AGENTE" ->  {:error, "NO_EXIST_POLICY"}
      text == "" -> {:ok, "EXIST"}
      :true -> {:error, "NO_EXIST_POLICY"}
    end

  end 

  defp get_dates do
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

  defp parse_policy(html) do
    info = Info.run(html)
    %{customer: customer} = %{customer: Customer.run(html)}
    receipts = %{receipts: Receipts.run(html)}

    raw_policy = info
                 |> Map.merge(customer)
                 |> Map.merge(receipts)

    props = raw_policy |> ComputedProperties.run()
    customer
    |> Map.merge(info)
    |> Map.merge(props)
  end
end
