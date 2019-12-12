defmodule Parkingappbackend.Sales do
  import Ecto.Query, warn: false
  alias Parkingappbackend.Repo
  alias Parkingappbackend.Sales.Booking
  alias Parkingappbackend.Space.Parking

  def list_bookings do
    query = from b in Booking,
    join: p in Parking,
    on: b.parking_id == p.id,
    select: %{status: b.status, id: b.id, start_time: b.start_time, end_time: b.end_time, calc_criteria: b.calc_criteria , parking_id: b.parking_id, user_id: b.user_id, parking_name: p.name}
    Repo.all(query)
  end

  def list_bookings(user) do
    query = from b in Booking,
    join: p in Parking,
    on: b.parking_id == p.id,
    where: b.user_id == ^user.id ,
    select: %{status: b.status, id: b.id, start_time: b.start_time, end_time: b.end_time, calc_criteria: b.calc_criteria , parking_id: b.parking_id, user_id: b.user_id, parking_name: p.name}
    Repo.all(query)
  end

  def list_bookings_active() do
    query = from b in Booking,
    join: p in Parking,
    on: b.parking_id == p.id,
    where: b.status == "OPEN",
    select: %{status: b.status, id: b.id, start_time: b.start_time, end_time: b.end_time, calc_criteria: b.calc_criteria , parking_id: b.parking_id, user_id: b.user_id, parking_name: p.name}
    Repo.all(query)
  end


  def list_bookings_userid(user_id) do
    query = from b in Booking, where: b.user_id == ^user_id
    Repo.all(query)
  end

  def get_booking!(id), do: Repo.get!(Booking, id)

  def create_booking(attrs \\ %{}) do
    %Booking{}
    |> Booking.changeset(attrs)
    |> Repo.insert()
  end

  def update_booking(%Booking{} = booking, attrs) do
    booking
    |> Booking.changeset(attrs)
    |> Repo.update()
  end

  def cancel_booking(%Booking{} = booking, attrs) do
    booking
    |> Booking.cancel_changeset(attrs)
    |> Repo.update()
  end

  def update_end_time(%Booking{} = booking, attrs) do
    booking
    |> Booking.update_endtime_changeset(attrs)
    |> Repo.update()
  end

  def delete_booking(%Booking{} = booking) do
    Repo.delete(booking)
  end

  def update_booking_status(%Booking{} = booking, attrs) do
    booking
    |> Booking.cancel_changeset(attrs)
    |> Repo.update()
  end

  def finish_bookings([h|t]) do
    booking = get_booking!(h.id)
    update_booking_status(booking, %{status: "COMPLETED"})
    finish_bookings(t)
  end

  def finish_bookings([]) do

  end

end
