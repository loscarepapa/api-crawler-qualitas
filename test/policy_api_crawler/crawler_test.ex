defmodule PolicyApiWeb.PolicysCrawlerTest do
  use PolicyApiWeb.ConnCase
    use Hound.Helpers

  describe "crawler" do
    @tag timeout: :infinity
    test "Chrome disable pdf viewer" do
      Hound.start_session(
        additional_capabilities: %{
          chromeOptions: %{ "prefs" => %{
            "plugins.always_open_pdf_externally": true,
            "download.prompt_for_download": false, 
            "download.default_directory": "/home/marvins/temp_chrome_downloads" 
          }}
        }
      )

      navigate_to "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
      require IEx;IEx.pry
    end
  end

end
