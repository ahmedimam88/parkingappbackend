defmodule ParkingappbackendWeb.BookingControllerTest do
  use ParkingappbackendWeb.ConnCase, async: true

  alias Parkingappbackend.Sales.Booking
  alias Parkingappbackend.Sales
  alias Parkingappbackend.Auth
  alias Parkingappbackend.Auth.User
  use Timex

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
    end_time: String.slice(elem(Timex.format(Timex.shift(Timex.now("GMT-2"), minutes: 30),"{RFC3339}"),1), 0..18) <> "+02:00",
    parking_id: 2,
    calc_criteria: 1,
    user_id: 1
    }

    @create_booking1 %{
        start_time: "2019-12-04T21:13:47.704Z",
        end_time: String.slice(elem(Timex.format(Timex.shift(Timex.now("GMT-2"), minutes: 1),"{RFC3339}"),1), 0..18) <> "+02:00" ,
        status: "OPEN",
        user_id: 1 ,
        parking_id: 1,
        calc_criteria: 1}

    @create_booking2 %{
        start_time: "2019-12-04T21:13:47.704Z",
        end_time: String.slice(elem(Timex.format(Timex.shift(Timex.now("GMT-2"), minutes: 5),"{RFC3339}"),1), 0..18) <> "+02:00" ,
        status: "OPEN",
        user_id: 2 ,
        parking_id: 2,
        calc_criteria: 1}

    @create_booking3 %{
        start_time: "2019-12-04T21:13:47.704Z",
        end_time: String.slice(elem(Timex.format(Timex.shift(Timex.now("GMT-2"), minutes: 15),"{RFC3339}"),1), 0..18) <> "+02:00" ,
        status: "OPEN",
        user_id: 3 ,
        parking_id: 2,
        calc_criteria: 1}

    @update_booking_valid %{ start_time: "New time", end_time: String.slice(elem(Timex.format(Timex.shift(Timex.now("GMT-2"), minutes: 15),"{RFC3339}"),1), 0..18) <> "+02:00", parking_id: 2, calc_criteria: 1 }

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
    {:ok, _} = Sales.create_booking(@create_booking1)
    {:ok, _} = Sales.create_booking(@create_booking2)
    {:ok, _} = Sales.create_booking(@create_booking3)

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
      assert length(json_response(conn, 200)) == 4
    end

    test "List bookings when booking less than 10", %{conn: conn} do
      conn = get(conn, Routes.booking_path(conn, :index_10min))
      assert length(json_response(conn, 200)) == 2
    end

    test "List bookings when booking less than 2", %{conn: conn} do
      conn = get(conn, Routes.booking_path(conn, :index_2min))
      assert length(json_response(conn, 200)) == 1
    end

  end

describe "create" do
  test "2.1 2.2 2.4 Create new booking with valid data", %{conn: conn} do
    conn = post(conn, Routes.booking_path(conn, :create), @create_booking_valid)

    assert %{ "parking_id" => 2 , "start_time" => "some time" , "end_time" => _, "status" => "OPEN"} = json_response(conn, 200)
    parking = Parkingappbackend.Space.get_parking!(2)
    assert parking.status == "BUSY"
  end

  test "2.1 2.2 Create new booking with invalid data", %{conn: conn} do
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

 describe "End" do
  test "End one booking" , %{conn: conn} do
    book = Sales.list_bookings() |> hd
    user = Auth.get_user!(book.user_id)

    {:ok, jwt, _claims} = Parkingappbackend.Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    conn = post(conn, Routes.booking_path(conn, :end_booking), %{id: book.id, end_time: "any End Time"})
    assert "any End Time" == json_response(conn, 200)["end_time"]
    assert "COMPLETED" == json_response(conn, 200)["status"]

  end
end

 describe "update booking" do

  test "when data is valid but unauthorized user", %{conn: conn} do
    book = Sales.list_bookings() |> hd
    conn = post(conn, Routes.booking_path(conn, :update), %{ id: book.id , start_time: "New time", end_time: "New time", parking_id: 2, calc_criteria: 1 })
    assert %{"detail" => "You are not authorized to update this booking"} = json_response(conn, 200)["errors"]
  end

  test "2.6 when data is valid for authorized user", %{conn: conn} do
    book = Sales.list_bookings() |> hd
    user = Auth.get_user!(book.user_id)

    {:ok, jwt, _claims} = Parkingappbackend.Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    conn = post(conn, Routes.booking_path(conn, :update), %{ id: book.id , start_time: "New time", end_time: "New time", parking_id: 2, calc_criteria: 1 })
    assert json_response(conn, 200)["start_time"] == "New time"
    assert json_response(conn, 200)["end_time"] == "New time"
  end
end

end
