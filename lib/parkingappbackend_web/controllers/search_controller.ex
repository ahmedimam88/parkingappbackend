defmodule ParkingappbackendWeb.SearchController do
  use ParkingappbackendWeb, :controller

  alias Parkingappbackend.Geolocation
  alias Parkingappbackend.Sales
  alias Parkingappbackend.Space

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
    Space.release_parkings(bookings)
    Sales.finish_bookings(bookings)

    [lat, long] = Geolocation.find_location(destination)
    parkings = Space.list_parkingsnear(lat, long)

    render(conn, "index.json", search: parkings)

  end

  def get_fees(conn, %{"parking_id" => parking_id, "starttime" => starttime, "endtime" => endtime}) do
    {id, name, latitude , longitude , status,catname, ratehour,raterealtime,freeminutes } = Space.get_parkingsCat(parking_id)


            min_diff = Timex.diff(Timex.parse!(endtime , "{RFC3339}") ,Timex.parse!(starttime , "{RFC3339}") , :minutes)
            fees_real = Float.ceil(min_diff/5) * raterealtime
            fees_hour = Float.ceil(min_diff/60) * ratehour
            render(conn, "fees.json", search: {id, name, latitude , longitude , status,catname, ratehour,raterealtime,freeminutes, fees_real, fees_hour })


  end

  def get_fees(conn, %{"parking_id" => parking_id, "starttime" => _}) do
    {id, name, latitude , longitude , status,catname, ratehour,raterealtime,freeminutes } = Space.get_parkingsCat(parking_id)
    fees_real = 0
            fees_hour = 0
            render(conn, "fees.json", search: {id, name, latitude , longitude , status,catname, ratehour,raterealtime,freeminutes, fees_real, fees_hour })

  end

end
