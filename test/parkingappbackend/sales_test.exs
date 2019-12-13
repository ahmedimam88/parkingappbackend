defmodule Parkingappbackend.SalesTest do
  use Parkingappbackend.DataCase, async: true

  alias Parkingappbackend.Sales
  alias Parkingappbackend.Sales.Booking

  describe "categories" do
    @valid_attrs %{start_time: "Some Time", end_time: "some time", status: "Some Status", parking_id: 1, calc_criteria: 1, user_id: 1}
    @update_attrs %{start_time: "Some Time New", end_time: "some time New", status: "Some Status", parking_id: 1, calc_criteria: 1, user_id: 1}
    @invalid_attrs %{start_time: nil, end_time: nil, status: nil, parking_id: nil, calc_criteria: nil, user_id: nil}

  def booking_fixture(attrs \\ %{}) do
    {:ok, booking} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Sales.create_booking()

      booking
  end


  test "list_bookings/0 returns all categories" do
    booking = booking_fixture()
    assert hd(Sales.list_bookings()).id == booking.id
  end

  test "get_booking!/1 returns the booking with given id" do
    booking = booking_fixture()
    assert Sales.get_booking!(booking.id) == booking
  end

  test "create_booking/1 with valid data creates a booking" do
    assert {:ok, %Booking{} = booking} = Sales.create_booking(@valid_attrs)
    assert booking.start_time == "Some Time"
    assert booking.end_time == "some time"
    assert booking.status == "Some Status"
    assert booking.parking_id == 1
    assert booking.calc_criteria == 1
    assert booking.user_id == 1
  end

  test "create_booking/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Sales.create_booking(@invalid_attrs)
  end

  test "update_booking/2 with valid data updates the booking" do
    booking = booking_fixture()
    assert {:ok, %Booking{} = booking} = Sales.update_booking(booking, @update_attrs)
    assert booking.start_time == "Some Time New"
    assert booking.end_time == "some time New"
    assert booking.status == "Some Status"
    assert booking.parking_id == 1
    assert booking.calc_criteria == 1
    assert booking.user_id == 1
  end

  test "update_booking/2 with invalid data returns error changeset" do
    booking = booking_fixture()
    assert {:error, %Ecto.Changeset{}} = Sales.update_booking(booking, @invalid_attrs)
    assert booking == Sales.get_booking!(booking.id)
  end

  test "cancel_booking/1 cancels the booking" do
    booking = booking_fixture()
    assert {:ok, %Booking{} = booking} = Sales.cancel_booking(booking, %{status: "CANCELLED"})
    assert booking.status == "CANCELLED"
  end

end
end
