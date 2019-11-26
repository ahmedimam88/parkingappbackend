defmodule Parkingappbackend.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :parkingappbackend,
  module: Parkingappbackend.Guardian,
  error_handler: Parkingappbackend.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
