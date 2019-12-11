defmodule Parkingappbackend.Repo.Migrations.CreatePaymentsTable do
    use Ecto.Migration

    def change do
      create table(:payments) do
        add :cardno, :string
        add :nameoncard, :string
        add :cvv, :integer
        add :expirydate, :string
        add :amount, :float
        add :status, :string
        add :booking_id, references(:bookings, on_delete: :nothing, type: :integer)
        add :user_id, references(:users, on_delete: :nothing, type: :integer)
        timestamps()
      end

    end
  end
