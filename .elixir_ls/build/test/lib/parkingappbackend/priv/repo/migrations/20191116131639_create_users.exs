defmodule Parkingappbackend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password_hash, :string
      add :email, :string
      add :address, :string
      add :age, :integer
      add :is_active, :boolean, default: false, null: false
      add :full_name, :string
      add :usertype, :string

      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
