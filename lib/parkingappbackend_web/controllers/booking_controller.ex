defmodule ParkingappbackendWeb.BookingController do
  use ParkingappbackendWeb, :controller

  import Ecto.Query, only: [from: 2]
  alias Parkingappbackend.Repo
  alias Parkingappbackend.Auth
  alias Parkingappbackend.Guardian
  alias Parkingappbackend.Sales.Booking
  alias Parkingappbackend.Sales
  use Timex

  action_fallback ParkingappbackendWeb.FallbackController


  def index_all(conn, _params) do
    bookings = Sales.list_bookings()
    render(conn, "index.json", bookings: bookings)
  end

  def index(conn, _params) do
    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    bookings = Sales.list_bookings(user)
    render(conn, "index.json", bookings: bookings)
  end


  def index_10min(conn, _params) do
    bookings = Sales.list_bookings_active()
    bookings = Enum.filter( bookings, fn(%{end_time: end_time}) -> Timex.diff(Timex.parse!(end_time , "{RFC3339}") ,Timex.now , :minutes) <= 10 end)
    render(conn, "index.json", bookings: bookings)
  end

  def index_2min(conn, _params) do
    bookings = Sales.list_bookings_active()
    bookings = Enum.filter( bookings, fn(%{end_time: end_time}) -> Timex.diff(Timex.parse!(end_time , "{RFC3339}") ,Timex.now , :minutes) <= 2 end)
    render(conn, "index.json", bookings: bookings)
  end

  def create(conn, %{"start_time" => start_time, "end_time" => end_time, "parking_id" => parking_id, "calc_criteria" => calc_criteria}) do

    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    query = from b in Booking, where: b.user_id == ^user.id and b.status == "OPEN"
    open_booking_count = Repo.all(query)
    case length(open_booking_count) == 0 do

    true ->
    case Sales.create_booking(%{start_time: start_time, end_time: end_time , status: "OPEN", user_id: user.id , parking_id: parking_id, calc_criteria: calc_criteria}) do
      {:ok, %Booking{} = booking} -> parking = Parkingappbackend.Space.get_parking!(parking_id)
                                    Parkingappbackend.Space.update_parking_status(parking,%{status: "BUSY"})
                                    booking = Map.put(booking, :parking_name, parking.name)
                                    render(conn, "show.json", booking: booking)
    _ ->  {:error, :Data_invalid}
    end

    _ -> message = "You can only have one open booking"
    conn
    |> put_view(ParkingappbackendWeb.ErrorView)
    |> render("401.json", message: message)
  end
  end

  def update(conn, %{"id" => id, "start_time" => start_time, "end_time" => end_time, "calc_criteria" => calc_criteria}) do
    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    booking = Sales.get_booking!(id)

    case booking.user_id == user.id do
      true ->
        with {:ok, %Booking{} = booking} <- Sales.update_booking(booking, %{start_time: start_time, end_time: end_time, calc_criteria: calc_criteria}) do
          parking = Parkingappbackend.Space.get_parking!(booking.parking_id)
          booking = Map.put(booking, :parking_name, parking.name)
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
          parking = Parkingappbackend.Space.get_parking!(booking.parking_id)
          Parkingappbackend.Space.update_parking_status(parking,%{status: "ACTIVE"})
          booking = Map.put(booking, :parking_name, parking.name)
          render(conn, "show.json", booking: booking)
        end
  end

end
end
