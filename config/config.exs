# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :parkingappbackend,
  ecto_repos: [Parkingappbackend.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :parkingappbackend, ParkingappbackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BMufSsNCgpnFm1Z7QWbj+7z/9H9OUgpLj2T583eukGMGj8peE/wjs92aBnUZ+xgi",
  render_errors: [view: ParkingappbackendWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Parkingappbackend.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"


# Guardian config
config :parkingappbackend, Parkingappbackend.Guardian,
       issuer: "parkingappbackend",
       secret_key: "vdRGAnH5je/0ByqLf+dxEXV/CH9tj+pHiYL4SI6fywhBI27Ky8erLNgESlNC+fIl"
