defmodule Parkingappbackend.Notification do

def fire_notification ([h|t]) do
  ParkingappbackendWeb.Endpoint.broadcast "user:#{h.user_id}", "new_link_added", %{"link" => %{"data" => "Your Active Booking is about to finish! , End Time : " <> h.end_time}}
  fire_notification(t)
end

def fire_notification ([]) do
end

end
