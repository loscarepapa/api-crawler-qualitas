defmodule PolicyApi.Repo do
  use Ecto.Repo,
    otp_app: :policy_api,
    adapter: Ecto.Adapters.Postgres
end
