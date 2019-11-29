defmodule ParkingappbackendWeb.UserView do
  use ParkingappbackendWeb, :view
  alias ParkingappbackendWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("inspect.json", %{user_params: user_params}) do
    %{data: user_params}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      address: user.address,
      is_active: user.is_active,
      age: user.age}
  end

  def render("sign_in.json", %{user: user}) do
        %{
             user: %{
             id: user.id,
            username: user.username
           }
        }
      end

      def render("jwt.json", %{jwt: jwt , user: user}) do
        %{jwt: jwt,
          user: %{
            user_id: user.id,
            username: user.username,
            email: user.email,
            address: user.address,
            age: user.age,
            isactive: user.is_active
          }
          }
      end

end
