defmodule Parkingappbackend.Billing do
  import Ecto.Query, warn: false
  alias Parkingappbackend.Repo
  alias Parkingappbackend.Sales.Booking
  alias Parkingappbackend.Billing.Payment
  alias Parkingappbackend.Auth.User

  def list_payments(user) do
    query = from p in Payment,
    join: b in Booking,
    on: p.booking_id == b.id,
    join: u in User,
    on: p.user_id == u.id,
    where: p.user_id == ^user.id ,
    select: %{id: p.id, cardno: p.cardno, nameoncard: p.nameoncard, cvv: "*", amount: p.amount, status: p.status , booking_id: b.id, start_time: b.start_time, end_time: b.end_time}
    Repo.all(query)
  end

  def list_completed_payments(user) do
    query = from p in Payment,
    join: b in Booking,
    on: p.booking_id == b.id,
    join: u in User,
    on: p.user_id == u.id,
    where: p.status == "COMPLETED" and p.user_id == ^user.id ,
    select: %{id: p.id, cardno: p.cardno, nameoncard: p.nameoncard, cvv: "*", amount: p.amount, status: p.status , booking_id: b.id, start_time: b.start_time, end_time: b.end_time}
    Repo.all(query)
  end

  def list_pending_payments(user) do
    query = from p in Payment,
    join: b in Booking,
    on: p.booking_id == b.id,
    join: u in User,
    on: p.user_id == u.id,
    where: p.status == "PENDING" and p.user_id == ^user.id ,
    select: %{id: p.id, cardno: p.cardno, nameoncard: p.nameoncard, cvv: "*", amount: p.amount, status: p.status , booking_id: b.id, start_time: b.start_time, end_time: b.end_time}
    Repo.all(query)
  end

  def get_payment!(id), do: Repo.get!(Payment, id)

  def create_payment(attrs \\ %{}) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert()
  end

  def update_card_det_payment(%Payment{} = payment, attrs) do
    payment
    |> Payment.card_update_changeset(attrs)
    |> Repo.update()
  end



  def update_payment_status(%Payment{} = payment, attrs) do
    payment
    |> Payment.status_update_changeset(attrs)
    |> Repo.update()
  end


end
