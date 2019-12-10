defmodule Parkingappbackend.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :age, :integer
    field :address, :string
    field :email, :string
    field :is_active, :boolean, default: false
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :full_name, :string
    field :usertype, :string, default: "CUSTOMER"
    field :paymentpreference, :string, default: "EOP"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :address, :age, :is_active, :password, :full_name, :usertype, :paymentpreference])
    |> validate_required([:username, :email, :password])
    |> validate_inclusion(:usertype, ~w(ADMIN CUSTOMER))
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> put_password_hash()
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :address, :age, :is_active, :full_name, :usertype, :paymentpreference])
    |> validate_required([:username, :email])
    |> validate_inclusion(:usertype, ~w(ADMIN CUSTOMER))
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

end
