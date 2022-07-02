defmodule CutiepyBroker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CutiepyBroker.Repo,
      # Start the Telemetry supervisor
      CutiepyBrokerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CutiepyBroker.PubSub},
      # Start CutiepyBroker's GenServers.
      CutiepyBroker.JobRunTimer,
      CutiepyBroker.JobTimer,
      {CutiepyBroker.DeferredJobEnqueuer, name: CutiepyBroker.DeferredJobEnqueuer},
      CutiepyBroker.DeferredJobWatcher,
      {CutiepyBroker.RepeatingJobEnqueuer, name: CutiepyBroker.RepeatingJobEnqueuer},
      CutiepyBroker.RepeatingJobWatcher,
      # Start the Endpoint (http/https)
      CutiepyBrokerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CutiepyBroker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CutiepyBrokerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
