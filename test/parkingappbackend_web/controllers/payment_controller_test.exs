defmodule ParkingappbackendWeb.PaymentControllerTest do
  use ParkingappbackendWeb.ConnCase
  alias Parkingappbackend.Billing.Payment
  alias Parkingappbackend.Billing
  alias Parkingappbackend.Sales
  alias Parkingappbackend.Sales.Booking

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
    end_time: String.slice(elem(Timex.format(Timex.shift(Timex.now("GMT-2"), minutes: 30),"{RFC3339}"),1), 0..18) <> "+02:00",
    parking_id: 2,
    calc_criteria: 1,
    user_id: 1
    }


    @create_booking_valid2 %{
      start_time: "some time",
      end_time: String.slice(elem(Timex.format(Timex.shift(Timex.now("GMT-2"), minutes: 30),"{RFC3339}"),1), 0..18) <> "+02:00",
      parking_id: 2,
      calc_criteria: 1,
      user_id: 2
      }

    @create_payment_pending %{
      cardno: "some cardno",
      nameoncard: "some nameoncard",
      expirydate: "some expirydate",
      cvv: 123,
      amount: 123,
      status: "PENDING"
    }

    @create_payment_completed %{
      cardno: "some cardno",
      nameoncard: "some nameoncard",
      expirydate: "some expirydate",
      cvv: 123,
      amount: 123,
      status: "COMPLETED"
    }

    @create_payment_invalid %{
      cardno: "some cardno",
      nameoncard: "some nameoncard",
      expirydate: "some expirydate",
      cvv: 123,
      amount: 123,
      status: "INVALID"
    }

    @create_payment %{
      cardno: nil,
      nameoncard: nil,
      expirydate: nil,
      cvv: nil,
      amount: 123,
      status: "PENDING"
    }

    @create_payment_user %{
      cardno: nil,
      nameoncard: nil,
      expirydate: nil,
      cvv: nil,
      amount: 123,
      status: "PENDING",
      user_id: 1
    }



  setup %{conn: conn} do
      {:ok, %User{} = user} = Auth.create_user(@create_login_user)
      {:ok, %Booking{} = booking} = Sales.create_booking(@create_booking_valid)
      payment_pending =  Map.put(@create_payment_pending, :user_id, user.id)
      payment_pending =  Map.put(payment_pending, :booking_id, booking.id)

      payment_completed =  Map.put(@create_payment_completed, :user_id, user.id)
      payment_completed =  Map.put(payment_completed, :booking_id, booking.id)

      payment_user =  Map.put(@create_payment_user, :booking_id, booking.id)

      {:ok, _} = Billing.create_payment(payment_pending)
      {:ok, _} = Billing.create_payment(payment_completed)
      {:ok, _} = Billing.create_payment(payment_user)

      {:ok, jwt, _claims} = Parkingappbackend.Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt}")
      {:ok, conn: conn}
    end


    describe "index" do
      test "lists all parkings related to a specific user", %{conn: conn} do
        conn = get(conn, Routes.payment_path(conn, :index))
        assert length(json_response(conn, 200)) == 2
      end

      test "List parkings with status PENDING", %{conn: conn} do
        conn = get(conn, Routes.payment_path(conn, :index_pending))
        assert length(json_response(conn, 200)) == 1
        assert hd(json_response(conn, 200))["status"] == "PENDING"
      end

      test "List parkings with status COMPLETED", %{conn: conn} do
        conn = get(conn, Routes.payment_path(conn, :index_completed))
        assert length(json_response(conn, 200)) == 1
        assert hd(json_response(conn, 200))["status"] == "COMPLETED"
      end

    end

    describe "create" do
      test "Create new payment with valid data", %{conn: conn} do
      {:ok, %Booking{} = booking} = Sales.create_booking(@create_booking_valid)

      payment =  Map.put(@create_payment, :user_id, 1)
      payment =  Map.put(payment, :booking_id, booking.id)
      conn = post(conn, Routes.payment_path(conn, :create), payment)

        assert %{ "id" => _,
                  "cardno" => nil,
                  "nameoncard" => nil,
                  "cvv" => nil,
                  "amount" => 123.0,
                  "status" => "PENDING",
                  "booking_id" => _,
                  "start_time" => _,
                  "end_time" => _} = json_response(conn, 200)
      end

      test "Create new payment with invalid data", %{conn: conn} do
        {:ok, %Booking{} = booking} = Sales.create_booking(@create_booking_valid)
        payment =  Map.put(@create_payment_invalid, :user_id, 1)
        payment =  Map.put(payment, :booking_id, booking.id)
        conn = post(conn, Routes.payment_path(conn, :create), payment)
        assert json_response(conn, 404)["errors"] != %{}
      end

    end

    describe "update payment" do

      test "when data is valid but unauthorized user", %{conn: conn} do
        user = Auth.get_user!(1)
        parking = Billing.list_payments(user) |> hd
        conn = post(conn, Routes.payment_path(conn, :update), %{id: parking.id , cardno: parking.cardno, nameoncard: "new nameoncard", expirydate: "some expirydate", cvv: parking.cvv, amount: parking.amount, status: parking.status})
        assert %{"detail" => "You are not authorized to update this payment"} = json_response(conn, 200)["errors"]
      end

      test "when data is valid for authorized user", %{conn: conn} do
        user = Auth.get_user!(1)
        payment = Billing.list_payments(user) |> hd

        {:ok, jwt, _claims} = Parkingappbackend.Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
        conn =
          conn
          |> put_req_header("accept", "application/json")
          |> put_req_header("authorization", "Bearer #{jwt}")

        conn = post(conn, Routes.payment_path(conn, :update), %{ id: payment.id , cardno: "updated nil", nameoncard: "updated nil", expirydate: "updated exp", cvv: 121 })
        assert json_response(conn, 200)["cardno"] == "updated nil"
        assert json_response(conn, 200)["nameoncard"] == "updated nil"
        assert json_response(conn, 200)["cvv"] == 121
      end

      test "when payment status only ", %{conn: conn} do
        user = Auth.get_user!(1)
        payment = Billing.list_payments(user) |> hd

        {:ok, jwt, _claims} = Parkingappbackend.Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
        conn =
          conn
          |> put_req_header("accept", "application/json")
          |> put_req_header("authorization", "Bearer #{jwt}")

        conn = post(conn, Routes.payment_path(conn, :update_status), %{ id: payment.id , status: "COMPLETED" })
        assert json_response(conn, 200)["status"] == "COMPLETED"
      end

      test "when payment amount and status in real time only", %{conn: conn} do
        user = Auth.get_user!(2)

        {:ok, jwt, _claims} = Parkingappbackend.Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
        conn =
          conn
          |> put_req_header("accept", "application/json")
          |> put_req_header("authorization", "Bearer #{jwt}")

        {:ok, %Booking{} = booking2} = Sales.create_booking(@create_booking_valid2)
        payment_RT =  Map.put(@create_payment_pending, :user_id, 2)
        payment_RT =  Map.put(payment_RT, :booking_id, booking2.id)
        {:ok, _} = Billing.create_payment(payment_RT)
        payment = Billing.list_payments(user) |> hd

        conn = post(conn, Routes.payment_path(conn, :update_amountRT), %{ booking_id: payment.booking_id , amount: 1000, status: "COMPLETED" })
        assert json_response(conn, 200)["status"] == "COMPLETED"
        assert json_response(conn, 200)["amount"] == 1000.0
      end

      test "payment status is invalid" do
        user = Auth.get_user!(1)
        payment = Billing.list_payments(user) |> hd

        {:ok, jwt, _claims} = Parkingappbackend.Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")

          conn = post(conn, Routes.payment_path(conn, :update_status), %{ id: payment.id , status: "WHATEVER" })
          assert json_response(conn, 422)["errors"] != %{}


      end

    end


end
