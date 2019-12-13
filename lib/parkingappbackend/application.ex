defmodule Parkingappbackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  use Supervisor

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Parkingappbackend.Repo,
      # Start the endpoint when the application starts
      ParkingappbackendWeb.Endpoint,
      worker(Parkingappbackend.Periodically, []),
      worker(Parkingappbackend.Periodically2, [])

      # Starts a worker by calling: Parkingappbackend.Worker.start_link(arg)
      # {Parkingappbackend.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Parkingappbackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ParkingappbackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
