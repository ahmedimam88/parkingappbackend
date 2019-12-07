defmodule ParkingappbackendWeb.LinksChannel do
  use Phoenix.Channel

  def join("links", _payload, socket) do
    {:ok, socket}
  end

  def join("user:"<> _user_id, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("new_link", payload, socket) do
    broadcast! socket, "new_link_added", payload
    {:noreply, socket}
  end

end
