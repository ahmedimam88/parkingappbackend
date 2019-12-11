defmodule ParkingappbackendWeb.PaymentView do
  use ParkingappbackendWeb, :view
  alias ParkingappbackendWeb.PaymentView

  def render("index.json", %{payments: payments}) do
    render_many(payments, PaymentView, "payment.json")
  end

  def render("show.json", %{payment: payment}) do
    render_one(payment, PaymentView, "payment.json")
  end

  def render("payment.json", %{payment: payment}) do
    %{id: payment.id,
    cardno: payment.cardno,
    nameoncard: payment.nameoncard,
    cvv: payment.cvv,
    amount: payment.amount,
    status: payment.status,
    booking_id: payment.booking_id,
    start_time: payment.start_time,
    end_time: payment.end_time}

  end



end
