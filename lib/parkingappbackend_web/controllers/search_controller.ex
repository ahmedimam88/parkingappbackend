defmodule ParkingappbackendWeb.SearchController do
  use ParkingappbackendWeb, :controller

  alias Parkingappbackend.Auth
  alias Parkingappbackend.Auth.User
  alias Parkingappbackend.Guardian
  alias Parkingappbackend.Geolocation

  def index(conn, _params) do
    parkings = Parkingappbackend.Space.list_parkingsCats()
    render(conn, "index.json", search: parkings)
  end

  def search_parkings(conn, %{"destination" => destination, "starttime" => starttime, "endtime" => endtime}) do

    [lat, long] = Geolocation.find_location(destination)
    parkings = Parkingappbackend.Space.list_parkingsnear(lat, long)
    render(conn, "index.json", search: parkings)

  end

end
