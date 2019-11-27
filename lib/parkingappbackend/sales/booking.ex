defmodule Parkingappbackend.Sales.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :start_time, :string
    field :end_time, :string
    field :status, :string, default: "OPEN"
    belongs_to :category, Parkingappbackend.Space.Category
    belongs_to :user, Parkingappbackend.Auth.User
    belongs_to :parking, Parkingappbackend.Space.Parking

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start_time, :end_time, :status])
    |> validate_required([:start_time, :start_time])
  end
end
