defmodule PolicyApi.Crawl do
  use Hound.Helpers
  alias PolicyApi.Utils, as: H
  alias PolicyApi.Parser.Customer
  alias PolicyApi.Parser.Info
  alias PolicyApi.Parser.ComputedProperties
  alias PolicyApi.Parser.Receipts
  alias PolicyApi.Parser.Pdf

  @notFound %{id: "messageDialog"}

  def run(credentials, number) do
    start_hound()

    policy = number
             |> valid_number()
             |> login?(credentials)
             |> policy_exist()
             |> get_dates()
             |> download_policy(number, credentials)
             |> parse_policy()

    policy

  end

  def start_hound() do
    try do
      Hound.start_session(
        additional_capabilities: %{
          chromeOptions: %{ "prefs" => %{
            "plugins.always_open_pdf_externally": true,
            "download.prompt_for_download": false, 
            "download.default_directory": "/home/marvins/dev/elixir/policy_api/file" 
          }}
        }
      )
    rescue
      _e in RuntimeError -> 
        Hound.end_session
        start_hound() 
    end
  end

  def valid_number(number) do
    val = String.length(number)
    cond do
      val == 10 ->  {:ok, number}
      :true ->  {:error, number}
    end
  end

  def login?({:error, message},_credentials) do {:error, message} end

  def login?({:ok, number}, [key, count, pass] = _credentials) do
    try do
      navigate_to("https://agentes.qualitas.com.mx/cas/login?service=https%3A%2F%2Fagentes.qualitas.com.mx%2Fc%2Fportal%2Flogin")
      fill_field(find_element(:name, "agente"), "#{key}")
      fill_field(find_element(:name, "username"), "#{count}")
      fill_field(find_element(:name, "password"), "#{pass}")
      find_element(:name, "submit") |> click() 
      found = visible_page_text() |> String.contains?("INFORMACIÓN")
      if found do
        {:ok, number}
      else
        {:error, "credentials invalids"}
      end
    rescue
      _e in RuntimeError ->  {:error, "credentials invalids"}
    end
  end

  defp policy_exist({:error, message}) do {:error, message} end

  defp policy_exist({:ok, number}) do
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
    exist? = cond do
      text =~ "NO VALIDA PARA EL AGENTE" ->  {:error, "NO_EXIST_POLICY"}
      text == "" -> {:ok, "EXIST"}
      :true -> {:error, "NO_EXIST_POLICY"}
    end

    exist?

  end 

  defp get_dates({:error, message}) do {:error, message} end

  defp get_dates({:ok, _}) do
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

    {:ok, info_html <> customer_html}

  end

  defp download_policy({:error, message},_, _) do {:error, message} end 

  defp download_policy({:ok, res}, number, [key, count, _pass] = _credentials) do 

    fun = "jQuery(this)._SelectModeOfPdfDialog('https://agentes.qualitas.com.mx/" <>
      "group/guest/poliza/-/consulta/pdf/poliza?p_p_lifecycle=2&p_p_resource_id=" <>
        "verPdfPoliza&p_p_cacheability=cacheLevelPage&_ConsultaPolizas_WAR_ConsultaPolizasportlet_agent=" <>
          key <>
    "&_ConsultaPolizas_WAR_ConsultaPolizasportlet_poliza=" <>
      number <>
    "&_ConsultaPolizas_WAR_ConsultaPolizasportlet_username=" <>
      count <>
    "',{numPolicy:'"<>
    "04#{number}000000" <>
    "',agentClav:" <>
      key <>
        "});" 

    focus_parent_frame()

    find_element(:xpath, "/html/body/div[5]/div[1]/button") |> click() 

    find_element(:id, "ifrConsultaPoliza")
    |> focus_frame()

    execute_script(fun)
    find_element(:xpath, "/html/body/div[3]/div[3]/div/button[1]") |> click() 

    pdf = H.wait_for_file("/home/marvins/dev/elixir/policy_api/file/poliza.pdf") |> Base.encode64

    {:ok, res, pdf}
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

  defp parse_policy({:error, message}) do {:error, message} end

  defp parse_policy({:ok, html, pdf}) do
    info = Info.run(html)
    %{customer: customer} = %{customer: Customer.run(html)}
    receipts = %{receipts: Receipts.run(html)}

    raw_policy = info
                 |> Map.merge(customer)
                 |> Map.merge(receipts)

    props = raw_policy |> ComputedProperties.run()
    res = customer
          |> Map.merge(info)
          |> Map.merge(props)
          |> Map.merge(%{pdf: pdf})
    res
  end
end
