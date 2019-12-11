defmodule Parkingappbackend.Repo.Migrations.CreateParkings do
  use Ecto.Migration

  def change do
    create table(:parkings) do
     # add :id, :integer, primary_key: true
      add :name, :string
      add :latitude, :float
      add :longitude, :float
      add :status, :string
      add :category_id, references(:categories, on_delete: :nothing, type: :integer)

      timestamps()
    end

    create unique_index(:parkings, [:name])
    create index(:parkings, [:category_id])
  end
end
