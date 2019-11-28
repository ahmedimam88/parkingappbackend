defmodule ParkingappbackendWeb.UserControllerTest do
  use ParkingappbackendWeb.ConnCase

  alias Parkingappbackend.Auth
  alias Parkingappbackend.Auth.User

  @create_attrs2 %{
    address: "some address",
    age: 42,
    email: "ahmeeee@email.com",
    is_active: true,
    password: "some123",
    username: "some1111111"
  }
  @create_attrs %{
    address: "some address",
    age: 42,
    email: "ahm2@email.com",
    is_active: "true",
    password: "some123",
    username: "some12"
  }
  @update_attrs %{
    id: 1,
    address: "some updated address",
    age: 43,
    email: "some updated email",
    is_active: false
    }
  @invalid_attrs %{id: 1, address: nil, age: nil, email: nil, is_active: nil}

  setup %{conn: conn} do
    {:ok, %User{} = user} = Auth.create_user(@create_attrs)

        {:ok, jwt, _claims} = Parkingappbackend.Guardian.encode_and_sign(user, %{}, ttl: {4, :hours}, token_type: "refresh")
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
    {:ok, conn: conn}
  end



  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert length(json_response(conn, 200)) == 5
    end
  end

  describe "show" do
    test "show current user" , %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show))

      assert %{
               "address" => "some address",
               "age" => 42,
               "email" => "ahm2@email.com",
               "is_active" => true,
               "username" => "some12"
             } = json_response(conn, 200)
      end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @create_attrs2)
      assert %{"jwt" => jwt} = json_response(conn, 201)

    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do

    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :update), @update_attrs)
      assert %{
               "address" => "some updated address",
               "age" => 43,
               "email" => "some updated email",
               "is_active" => false
               } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :update), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end


end
