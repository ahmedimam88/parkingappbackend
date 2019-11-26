defmodule Parkingappbackend.Repo do
  use Ecto.Repo,
    otp_app: :parkingappbackend,
    adapter: Ecto.Adapters.Postgres
end
