defmodule PolicyApiWeb.DefaultController do
  use PolicyApiWeb, :controller

  def index(conn, _params) do
    text conn, "PolicyApi"
  end
end
