defmodule Parkingappbackend.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
   #   add :id, :integer, primary_key: true
      add :name, :string
      add :ratehour, :float
      add :raterealtime, :float
      add :freeminutes, :integer
      add :status, :string

      timestamps()
    end

    create unique_index(:categories, [:name])
  end
end
