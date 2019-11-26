defmodule Parkingappbackend.Space.Category do
  use Ecto.Schema
  import Ecto.Changeset

  #@primary_key {:id, :binary_id, autogenerate: true}
  #@foreign_key_type :binary_id
  schema "categories" do
    field :freeminutes, :integer
    field :name, :string
    field :ratehour, :float
    field :raterealtime, :float
    field :status, :string
    has_many :parkings, Parkingappbackend.Space.Parking

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :ratehour, :raterealtime, :freeminutes, :status])
    |> validate_required([:name, :ratehour, :raterealtime, :freeminutes, :status])
    |> unique_constraint(:name)
  end
end
