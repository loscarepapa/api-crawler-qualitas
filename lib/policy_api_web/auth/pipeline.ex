defmodule PolicyApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :policy_api,
    module: PolicyApiWeb.Auth.Guardian,
    error_handler: PolicyApiWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
