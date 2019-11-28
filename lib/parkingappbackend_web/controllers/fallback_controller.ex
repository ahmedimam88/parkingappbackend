defmodule ParkingappbackendWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ParkingappbackendWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ParkingappbackendWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :secret_not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ParkingappbackendWeb.ErrorView)
    |> render(:"405")
  end

  def call(conn, {:error, :Data_invalid}) do
    conn
    |> put_status(:not_found)
    |> put_view(ParkingappbackendWeb.ErrorView)
    |> json(%{error: "Incorrect Data Provided"})
  end



  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Login error"})
  end

  def call(conn, {:error, %Ecto.Changeset{}}) do
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ParkingappbackendWeb.ErrorView)
        |> render(:"422")
      end

end
