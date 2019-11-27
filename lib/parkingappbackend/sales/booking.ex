defmodule Parkingappbackend.Sales.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :start_time, :string
    field :end_time, :string
    field :status, :string, default: "OPEN"
    field :calc_criteria, :integer
    belongs_to :user, Parkingappbackend.Auth.User
    belongs_to :parking, Parkingappbackend.Space.Parking

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start_time, :end_time, :status, :parking_id, :calc_criteria, :user_id])
    |> validate_required([:start_time, :end_time])
  end

  def cancel_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status])
    |> validate_required([:status])
  end
end
