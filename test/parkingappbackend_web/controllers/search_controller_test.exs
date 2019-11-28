defmodule ParkingappbackendWeb.SearchControllerTest do
  use ParkingappbackendWeb.ConnCase

  alias Parkingappbackend.Auth
  alias Parkingappbackend.Auth.User

  @create_attrs %{
    address: "some address",
    age: 42,
    email: "ahmeeee@email.com",
    is_active: true,
    password: "some123",
    username: "some1111111"
  }

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
      # assert %{
      #       "destination" => "some destination",
      #        "starttime"   => "some start time",
      #        "endtime"     => "some end time"
      #         } = json_response(conn, 200)
      assert length(json_response(conn, 200)) == 7
      #assert length(json_response(conn, 200)) != 71

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
