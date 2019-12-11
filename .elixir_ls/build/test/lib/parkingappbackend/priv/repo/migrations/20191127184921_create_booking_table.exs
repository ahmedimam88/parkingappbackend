defmodule Parkingappbackend.Repo.Migrations.CreateBookingTable do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :start_time, :string
      add :end_time, :string
      add :status, :string, default: "OPEN"
      add :calc_criteria, :integer
      add :user_id, references(:users)
      add :parking_id, references(:parkings)
      timestamps()
    end
  end
end
