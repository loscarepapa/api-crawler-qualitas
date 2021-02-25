defmodule PolicyApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PolicyApi.Repo,
      # Start the Telemetry supervisor
      PolicyApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PolicyApi.PubSub},
      # Start the Endpoint (http/https)
      PolicyApiWeb.Endpoint
      # Start a worker by calling: PolicyApi.Worker.start_link(arg)
      # {PolicyApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PolicyApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PolicyApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
