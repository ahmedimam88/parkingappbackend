defmodule Parkingappbackend.Billing.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :cardno, :string
    field :nameoncard, :string
    field :cvv, :integer
    field :expirydate, :string
    field :amount, :float
    field :status, :string, default: "PENDING"
    belongs_to :booking, Parkingappbackend.Sales.Booking
    belongs_to :user, Parkingappbackend.Auth.User

    timestamps()
  end

  @doc false
  def changeset(payments, attrs) do
    payments
    |> cast(attrs, [:cardno, :nameoncard, :cvv, :expirydate, :amount, :status, :user_id, :booking_id])
    |> validate_required([:amount, :status, :user_id, :booking_id])
    |> validate_inclusion(:status, ~w(PENDING COMPLETED))
  end

  def card_update_changeset(payments, attrs) do
    payments
    |> cast(attrs, [:cardno, :nameoncard, :cvv, :expirydate])
    |> validate_required([:cardno, :nameoncard, :cvv, :expirydate])
  end

  def status_update_changeset(payments, attrs) do
    payments
    |> cast(attrs, [:status])
    |> validate_required([:status])
    |> validate_inclusion(:status, ~w(PENDING COMPLETED))
  end
end
