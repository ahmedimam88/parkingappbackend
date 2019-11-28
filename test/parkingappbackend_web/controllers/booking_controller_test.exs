defmodule ParkingappbackendWeb.BookingControllerTest do
  use ParkingappbackendWeb.ConnCase
  alias Parkingappbackend.Sales.Booking
  alias Parkingappbackend.Sales
  alias Parkingappbackend.Auth
  alias Parkingappbackend.Auth.User

  @create_login_user %{
    address: "some address",
    age: 42,
    email: "ahm2@email.com",
    is_active: "true",
    password: "some123",
    username: "some12"
  }

  @create_booking_valid %{
    start_time: "some time",
    end_time: "some time",
    parking_id: 2,
    calc_criteria: 1,
    user_id: 1
    }

    @update_booking_valid %{ start_time: "New time", end_time: "New time", parking_id: 2, calc_criteria: 1 }

    @update_booking_invalid %{ start_time: nil, end_time: nil, parking_id: nil, calc_criteria: nil }

    @create_booking_invalid %{
      start_time: nil,
      end_time: nil,
      parking_id: nil,
      calc_criteria: nil
      }

  setup %{conn: conn} do
    {:ok, %User{} = user} = Auth.create_user(@create_login_user)
    {:ok, _} = Sales.create_booking(@create_booking_valid)

        {:ok, jwt, _claims} = Parkingappbackend.Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all bookings related to a specific user", %{conn: conn} do
      conn = get(conn, Routes.booking_path(conn, :index))
      assert json_response(conn, 200) == []
    end

    test "lists all bookings", %{conn: conn} do
      conn = get(conn, Routes.booking_path(conn, :index_all))
      assert length(json_response(conn, 200)) == 1
    end

  end

describe "create" do
  test "Create new booking with valid data", %{conn: conn} do
    conn = post(conn, Routes.booking_path(conn, :create), @create_booking_valid)

    assert %{ "parking_id" => 2 , "start_time" => "some time" , "end_time" => "some time", "status" => "OPEN"} = json_response(conn, 200)
  end

  test "Create new booking with invalid data", %{conn: conn} do
    conn = post(conn, Routes.booking_path(conn, :create), @create_booking_invalid)
    assert json_response(conn, 404)["errors"] != %{}
  end

end


  describe "Cancel" do
    test "Cancel one booking" , %{conn: conn} do
      book = Sales.list_bookings() |> hd
      conn = post(conn, Routes.booking_path(conn, :cancel), %{id: book.id})
      assert "CANCELLED" == json_response(conn, 200)["status"]

    end
 end

 describe "update booking" do

  test "when data is valid but unauthorized user", %{conn: conn} do
    book = Sales.list_bookings() |> hd
    conn = post(conn, Routes.booking_path(conn, :update), %{ id: book.id , start_time: "New time", end_time: "New time", parking_id: 2, calc_criteria: 1 })
    assert %{"detail" => "You are not authorized to update this booking"} = json_response(conn, 200)["errors"]
  end

  test "when data is valid for authorized user", %{conn: conn} do
    book = Sales.list_bookings() |> hd
    user = Auth.get_user!(book.user_id)

    {:ok, jwt, _claims} = Parkingappbackend.Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    conn = post(conn, Routes.booking_path(conn, :update), %{ id: book.id , start_time: "New time", end_time: "New time", parking_id: 2, calc_criteria: 1 })
    assert %{
             "calc_criteria" => 1,
             "end_time" => "New time",
             "parking_id" => 2,
             "start_time" => "New time",
             "status" => "OPEN"
             } = json_response(conn, 200)
  end
end


end
