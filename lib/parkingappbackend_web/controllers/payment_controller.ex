defmodule ParkingappbackendWeb.PaymentController do
  use ParkingappbackendWeb, :controller

  import Ecto.Query, only: [from: 2]

  alias Parkingappbackend.Billing
  alias Parkingappbackend.Billing.Payment
  alias Parkingappbackend.Sales.Booking
  alias Parkingappbackend.Sales
  alias Parkingappbackend.Auth
  alias Parkingappbackend.Guardian

  action_fallback ParkingappbackendWeb.FallbackController

  def index(conn, _params) do
    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    payments = Billing.list_payments(user)
    render(conn, "index.json", payments: payments)
  end

  def index_completed(conn, _params) do
    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    payments = Billing.list_completed_payments(user)
    render(conn, "index.json", payments: payments)
  end

  def index_pending(conn, _params) do
    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    payments = Billing.list_pending_payments(user)
    render(conn, "index.json", payments: payments)
  end

  def create(conn, %{"cardno" => cardno, "nameoncard" => nameoncard, "expirydate" => expirydate, "cvv" => cvv, "amount" => amount, "status" => status, "booking_id" => booking_id}) do

    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)

    case Billing.create_payment(%{cardno: cardno, nameoncard: nameoncard, expirydate: expirydate, cvv: cvv, amount: amount, status: status, booking_id: booking_id, user_id: user.id}) do
    {:ok, %Payment{} = payment} ->
      booking = Sales.get_booking!(payment.booking_id)
      payment =  Map.put(payment, :start_time, booking.start_time)
      payment =  Map.put(payment, :end_time, booking.end_time)
      render(conn, "show.json", payment: payment)
    _ ->  {:error, :Data_invalid}
    end

  end

  def update(conn,%{"id" => id , "cardno" => cardno, "nameoncard" => nameoncard, "expirydate" => expirydate, "cvv" => cvv}) do
    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    payment = Billing.get_payment!(id)

    case payment.user_id == user.id do
      true ->
        with {:ok, %Payment{} = payment} <- Billing.update_card_det_payment(payment, %{cardno: cardno, nameoncard: nameoncard, expirydate: expirydate, cvv: cvv}) do
          booking = Sales.get_booking!(payment.booking_id)
          payment =  Map.put(payment, :start_time, booking.start_time)
          payment =  Map.put(payment, :end_time, booking.end_time)
              render(conn, "show.json", payment: payment)
        end
      _ -> message = "You are not authorized to update this payment"
            conn
            |> put_view(ParkingappbackendWeb.ErrorView)
            |> render("401.json", message: message)

    end


  end

  def update_status(conn,%{"id" => id , "status" => status}) do
    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    payment = Billing.get_payment!(id)

    case payment.user_id == user.id do
      true ->
        with {:ok, %Payment{} = payment} <- Billing.update_payment_status(payment, %{status: status}) do
          booking = Sales.get_booking!(payment.booking_id)
          payment =  Map.put(payment, :start_time, booking.start_time)
          payment =  Map.put(payment, :end_time, booking.end_time)
              render(conn, "show.json", payment: payment)
        end
      _ -> message = "You are not authorized to update this payment"
            conn
            |> put_view(ParkingappbackendWeb.ErrorView)
            |> render("401.json", message: message)

    end


  end




end
