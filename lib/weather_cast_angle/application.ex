defmodule WeatherCastAngle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WeatherCastAngleWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:weather_cast_angle, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WeatherCastAngle.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WeatherCastAngle.Finch},
      # Start a worker by calling: WeatherCastAngle.Worker.start_link(arg)
      # {WeatherCastAngle.Worker, arg},
      # Start to serve requests, typically the last entry
      WeatherCastAngleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WeatherCastAngle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WeatherCastAngleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
