defmodule Parkingappbackend.Space do
  @moduledoc """
  The Space context.
  """

  import Ecto.Query, warn: false
  alias Parkingappbackend.Repo

  alias Parkingappbackend.Space.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  alias Parkingappbackend.Space.Parking

  @doc """
  Returns the list of parkings.

  ## Examples

      iex> list_parkings()
      [%Parking{}, ...]

  """
  def list_parkings do
    Repo.all(Parking)
  end

  def list_parkingsCats do
    query = from p in Parking,
          join: c in Category, on: c.id == p.category_id,
          select: {p.id , p.name, p.latitude , p.longitude, p.status , c.name, c.ratehour , c.raterealtime, c.freeminutes}
    Repo.all(query)
  end

  def list_parkingsnear(lat , long) do
    query = from p in Parking,
          join: c in Category, on: c.id == p.category_id,
          where: fragment("? BETWEEN ? AND ?", p.latitude, ^lat-0.000797, ^lat+0.000797),
          where: fragment("? BETWEEN ? AND ?", p.longitude, ^long-0.001092, ^long+0.001092),
          select: {p.id , p.name, p.latitude , p.longitude, p.status , c.name, c.ratehour , c.raterealtime, c.freeminutes}
    Repo.all(query)
  end

  def list_parkingcatnear(lat , long, cat) do
      query = from p in Parking,
            join: c in Category, on: c.id == p.category_id,
            where: fragment("? BETWEEN ? AND ?", p.latitude, ^lat-1, ^lat+1),
            where: fragment("? BETWEEN ? AND ?", p.longitude, ^long-1, ^long+1),
            select: {p.id , p.name, p.latitude , p.longitude, p.status , c.name, c.ratehour , c.raterealtime, c.freeminutes}
      Repo.all(query)
    end

  @doc """
  Gets a single parking.

  Raises `Ecto.NoResultsError` if the Parking does not exist.

  ## Examples

      iex> get_parking!(123)
      %Parking{}

      iex> get_parking!(456)
      ** (Ecto.NoResultsError)

  """
  def get_parking!(id), do: Repo.get!(Parking, id)

  @doc """
  Creates a parking.

  ## Examples

      iex> create_parking(%{field: value})
      {:ok, %Parking{}}

      iex> create_parking(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_parking(attrs \\ %{}) do
    %Parking{}
    |> Parking.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a parking.

  ## Examples

      iex> update_parking(parking, %{field: new_value})
      {:ok, %Parking{}}

      iex> update_parking(parking, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_parking(%Parking{} = parking, attrs) do
    parking
    |> Parking.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Parking.

  ## Examples

      iex> delete_parking(parking)
      {:ok, %Parking{}}

      iex> delete_parking(parking)
      {:error, %Ecto.Changeset{}}

  """
  def delete_parking(%Parking{} = parking) do
    Repo.delete(parking)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking parking changes.

  ## Examples

      iex> change_parking(parking)
      %Ecto.Changeset{source: %Parking{}}

  """
  def change_parking(%Parking{} = parking) do
    Parking.changeset(parking, %{})
  end
end
