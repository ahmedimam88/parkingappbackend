defmodule ParkingappbackendWeb.SearchController do
  use ParkingappbackendWeb, :controller

  alias Parkingappbackend.Geolocation
  alias Parkingappbackend.Sales

  def index(conn, _params) do
    parkings = Parkingappbackend.Space.list_parkingsCats()
    render(conn, "index.json", search: parkings)
  end

  def get_detail(conn, %{"parking_id" => parking_id}) do
    search = Parkingappbackend.Space.get_parkingsCat(parking_id)
    render(conn, "parking.json", search: search)
  end

  def search_parkings(conn, %{"destination" => destination, "starttime" => starttime, "endtime" => endtime}) do


    bookings = Sales.list_bookings_active()
    bookings = Enum.filter( bookings, fn(%{end_time: end_time}) -> Timex.diff(Timex.parse!(end_time , "{RFC3339}") ,Timex.now , :minutes) <= 2 end)
    Parkingappbackend.Space.release_parkings(bookings)
    Parkingappbackend.Sales.finish_bookings(bookings)

    [lat, long] = Geolocation.find_location(destination)
    parkings = Parkingappbackend.Space.list_parkingsnear(lat, long)

    render(conn, "index.json", search: parkings)

  end

end
