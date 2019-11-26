defmodule Parkingappbackend.Space.Parking do
  use Ecto.Schema
  import Ecto.Changeset

  #@primary_key {:id, :binary_id, autogenerate: true}
  #@foreign_key_type :binary_id
  schema "parkings" do
    field :latitude, :float
    field :longitude, :float
    field :name, :string
    field :status, :string
    field :category_id, :integer

    timestamps()
  end

  @doc false
  def changeset(parking, attrs) do
    parking
    |> cast(attrs, [:name, :latitude, :longitude, :status, :category_id])
    |> validate_required([:name, :latitude, :longitude, :status, :category_id])
    |> unique_constraint(:name)
  end
end
