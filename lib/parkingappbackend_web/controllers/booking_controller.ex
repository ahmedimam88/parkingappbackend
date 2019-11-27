defmodule ParkingappbackendWeb.BookingController do
  use ParkingappbackendWeb, :controller

  import Ecto.Query, only: [from: 2]

  alias Parkingappbackend.Auth
  alias Parkingappbackend.Guardian
  alias Parkingappbackend.Sales.Booking
  alias Parkingappbackend.Sales

  def index_all(conn, _params) do
    bookings = Sales.list_bookings()
    render(conn, "index.json", bookings: bookings)
  end

  def index(conn, _params) do
    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    bookings = Sales.list_bookings(user)
    render(conn, "index.json", bookings: bookings)
  end

  def create(conn, %{"start_time" => start_time, "end_time" => end_time, "parking_id" => parking_id, "calc_criteria" => calc_criteria}) do

    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    with {:ok, %Booking{} = booking} <- Sales.create_booking(%{start_time: start_time, end_time: end_time , status: "OPEN", user_id: user.id , parking_id: parking_id, calc_criteria: calc_criteria}) do
      render(conn, "show.json", booking: booking)
    end
  end

  def update(conn, %{"id" => id, "start_time" => start_time, "end_time" => end_time, "calc_criteria" => calc_criteria}) do
    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    booking = Sales.get_booking!(id)

    case booking.user_id == user.id do
      true ->
        with {:ok, %Booking{} = booking} <- Sales.update_booking(booking, %{start_time: start_time, end_time: end_time, calc_criteria: calc_criteria}) do
          render(conn, "show.json", booking: booking)
        end
      _ -> message = "You are not authorized to update this booking"
            conn
            |> put_view(ParkingappbackendWeb.ErrorView)
            |> render("401.json", message: message)

    end


  end

  def cancel(conn, %{"id" => id}) do
    #user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    booking = Sales.get_booking!(id)
    case booking.status do
     "CANCELLED" ->
          message = "This booking is already cancelled"
          conn
          |> put_view(ParkingappbackendWeb.ErrorView)
          |> render("401.json", message: message)

    _ ->
        with {:ok, %Booking{} = booking} <- Sales.cancel_booking(booking, %{status: "CANCELLED"}) do
          render(conn, "show.json", booking: booking)
        end
  end

end
end
