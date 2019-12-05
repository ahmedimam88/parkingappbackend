defmodule ParkingappbackendWeb.SearchControllerTest do
  use ParkingappbackendWeb.ConnCase

  alias Parkingappbackend.Auth
  alias Parkingappbackend.Auth.User
  use Timex

  @create_attrs %{
    address: "some address",
    age: 42,
    email: "ahmeeee@email.com",
    is_active: true,
    password: "some123",
    username: "some1111111"
  }

  @create_booking1 %{start_time: "2019-12-04T21:13:47.704Z", end_time: "2019-12-05T01:13:00+02:00" , status: "OPEN", user_id: 1 , parking_id: 1, calc_criteria: 1}
  @create_booking2 %{start_time: "2019-12-04T21:13:47.704Z", end_time: "2020-12-05T01:13:00+02:00" , status: "OPEN", user_id: 2 , parking_id: 2, calc_criteria: 1}


  setup %{conn: conn} do
    {:ok, %User{} = user} = Auth.create_user(@create_attrs)

        {:ok, jwt, _claims} = Parkingappbackend.Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
    {:ok, conn: conn}
  end

  describe "index" do
    test "list all parkings", %{conn: conn} do
      conn = get(conn, Routes.search_path(conn, :index))
      assert length(json_response(conn, 200)) == 71
    end
  end

  describe "search" do
    test "searh for a parking", %{conn: conn} do
      conn = post(conn, Routes.search_path(conn, :search_parkings), %{destination: "Raatuse 22, Tartu", starttime: "10:30", endtime: "12:00"})
      assert length(json_response(conn, 200)) == 7

    end

    test "search parking is updated to free when booking date is finished", %{conn: conn} do
      post(conn, Routes.booking_path(conn, :create), @create_booking1)
      parking1 = Parkingappbackend.Space.get_parking!(1)
      assert parking1.status == "BUSY"
      post(conn, Routes.search_path(conn, :search_parkings), %{destination: "Raatuse 22, Tartu", starttime: "10:30", endtime: "12:00"})
      parking1 = Parkingappbackend.Space.get_parking!(1)
      assert parking1.status == "ACTIVE"
    end

    test "search parking is not updated to free when booking date is still in future", %{conn: conn} do
      post(conn, Routes.booking_path(conn, :create), @create_booking2)
      parking2 = Parkingappbackend.Space.get_parking!(2)
      assert parking2.status == "BUSY"
      post(conn, Routes.search_path(conn, :search_parkings), %{destination: "Raatuse 22, Tartu", starttime: "10:30", endtime: "12:00"})
      parking2 = Parkingappbackend.Space.get_parking!(2)
      assert parking2.status == "BUSY"
    end

    test "search for a parking for a different location", %{conn: conn} do
      conn = post(conn, Routes.search_path(conn, :search_parkings), %{destination: "Raekoja Platz, Tartu", starttime: "12:30", endtime: "14:00"})
      assert length(json_response(conn, 200)) == 3
      assert length(json_response(conn, 200)) > 1
      assert length(json_response(conn, 200)) != 0

    end
    test "check the correct number of parking spots for particular parking space", %{conn: conn} do
      conn = post(conn, Routes.search_path(conn, :search_parkings), %{destination: "Maxima Narva, Tartu", starttime: "12:30", endtime: "14:00"})
      assert length(json_response(conn, 200)) != 71
    end

    test "there are no parking spaces in Tallinn", %{conn: conn} do
      conn = post(conn, Routes.search_path(conn, :search_parkings), %{destination: "Old Town, Tallinn", starttime: "10:00", endtime: "12:00"})
      assert [] = json_response(conn, 200)
    end

  end

end
