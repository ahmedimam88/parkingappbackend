defmodule ParkingappbackendWeb.UserController do
  use ParkingappbackendWeb, :controller


  alias Parkingappbackend.Auth
  alias Parkingappbackend.Auth.User
  alias Parkingappbackend.Guardian

  action_fallback ParkingappbackendWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def sign_in(conn, %{"username" => username, "password" => password}) do
    user = Auth.get_user_by_username(username)
    case Parkingappbackend.Auth.token_sign_in(username, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token, user: user)
      _ ->
        {:error, :unauthorized}
    end
        # case Parkingappbackend.Auth.authenticate_user(username, password) do
        #   {:ok, user} ->
        #     conn
        #     |> put_status(:ok)
        #     |> put_view(ParkingappbackendWeb.UserView)
        #     |> render("sign_in.json", user: user)

        #   {:error, message} ->
        #     conn
        #     |> put_status(:unauthorized)
        #     |> put_view(ParkingappbackendWeb.ErrorView)
        #     |> render("401.json", message: message)
        # end
      end

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Auth.create_user(user_params),
          {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
            conn
            |> put_status(:created)
            |> render("jwt.json", jwt: token, user: user)
      # conn
      # |> put_status(:created)
      # |> put_resp_header("location", Routes.user_path(conn, :show, user))
      # |> render("show.json", user: user)
    end
  end

  def show(conn, _) do
    user = Auth.get_user!(Guardian.Plug.current_resource(conn).id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "email" => email, "address" => address , "age" => age, "is_active" => is_active, "full_name" => full_name , "usertype" => usertype}) do
    user = Auth.get_user!(id)
    with {:ok, %User{} = user} <- Auth.update_user(user, %{email: email, address: address, age: age, is_active: is_active, full_name: full_name , usertype: usertype}) do
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "password" => password}) do
    user = Auth.get_user!(id)
    with {:ok, %User{} = user} <- Auth.update_user_password(user, %{password: password}) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
