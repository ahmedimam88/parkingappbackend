use Mix.Config

# Configure your database
config :parkingappbackend, Parkingappbackend.Repo,
  username: "postgres",
  password: "A1234567890",
  database: "parkingappbackend_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :parkingappbackend, ParkingappbackendWeb.Endpoint,
  http: [port: 4002],
  server: true #it was false initially

# Print only warnings and errors during test
config :logger, level: :warn
config :pbkdf2_elixir, :log_rounds, 4

# Add the following lines at the end of the file
config :hound, driver: "chrome_driver"
config :parkingappbackend, sql_sandbox: true

config :bitbucket_pipelines_test, BitbucketPipelinesTest.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: "postgres://postgres:pipelines-test@localhost/test-db"
