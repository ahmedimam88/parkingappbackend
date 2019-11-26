use Mix.Config

# Configure your database
config :parkingappbackend, Parkingappbackend.Repo,
  username: "postgres",
<<<<<<< HEAD
  password: "123",
=======
  password: "A1234567890",
>>>>>>> f5018206d10f78fb326a34e93e4193e3aa473dd5
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
