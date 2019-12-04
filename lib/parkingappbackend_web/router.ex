defmodule ParkingappbackendWeb.Router do
  use ParkingappbackendWeb, :router

  alias Parkingappbackend.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api", ParkingappbackendWeb do
    pipe_through :api
    post "/users/sign_up", UserController, :create
    post "/users/sign_in", UserController, :sign_in
    #get "/users", UserController, :index
  end

  scope "/api", ParkingappbackendWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/users", UserController, :index
    post "/users/update" , UserController, :update
    get "/my_account", UserController, :show
    post "/search", SearchController, :search_parkings
    get "/search/index", SearchController, :index
    get "/bookings/all", BookingController, :index_all
    get "/bookings/10min" , BookingController, :index_10min
    get "/bookings/2min" , BookingController, :index_2min
    get "/bookings", BookingController, :index
    post "/bookings/new", BookingController, :create
    post "/bookings/cancel", BookingController, :cancel
    post "/bookings/update", BookingController, :update
  end

end
