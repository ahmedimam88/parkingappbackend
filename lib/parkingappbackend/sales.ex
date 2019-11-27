defmodule Parkingappbackend.Sales do
  import Ecto.Query, warn: false
  alias Parkingappbackend.Repo
  alias Parkingappbackend.Sales.Booking

  def list_bookings do
    Repo.all(Booking)
  end

  def list_bookings(user) do
    query = from b in Booking, where: b.user_id == ^user.id
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

  def delete_booking(%Booking{} = booking) do
    Repo.delete(booking)
  end

end
