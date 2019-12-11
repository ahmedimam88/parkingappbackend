defmodule Parkingappbackend.Repo.Migrations.UpdateUsersTableAddPaymentPreference do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :paymentpreference, :string, default: "EOP"
    end
  end
end
