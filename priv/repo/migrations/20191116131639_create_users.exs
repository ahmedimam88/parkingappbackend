defmodule Parkingappbackend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :password_hash, :string
      add :email, :string
      add :address, :string
      add :age, :integer
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
