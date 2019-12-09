defmodule ParkingappbackendWeb.BookingView do
  use ParkingappbackendWeb, :view
  alias ParkingappbackendWeb.BookingView


  def render("index.json", %{bookings: bookings}) do
    render_many(bookings, BookingView, "booking.json")
  end

  def render("show.json", %{booking: booking}) do
    render_one(booking, BookingView, "booking.json")
  end

  def render("booking.json", %{booking: booking}) do
    %{id: booking.id,
      start_time: booking.start_time,
      end_time: booking.end_time,
      user_id: booking.user_id,
      parking_id: booking.parking_id,
      calc_criteria: booking.calc_criteria,
      status: booking.status,
      parking_name: booking.parking_name}
  end

end
