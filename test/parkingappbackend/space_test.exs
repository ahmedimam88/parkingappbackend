defmodule Parkingappbackend.SpaceTest do
  use Parkingappbackend.DataCase, async: true

  alias Parkingappbackend.Space

  describe "categories" do
    alias Parkingappbackend.Space.Category

    @valid_attrs %{freeminutes: 42, name: "some name", ratehour: 120.5, raterealtime: 120.5, status: "some status"}
    @update_attrs %{freeminutes: 43, name: "some updated name", ratehour: 456.7, raterealtime: 456.7, status: "some updated status"}
    @invalid_attrs %{freeminutes: nil, name: nil, ratehour: nil, raterealtime: nil, status: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Space.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      ##assert Space.list_categories() == [category]
      assert length(Space.list_categories()) == 6
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Space.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Space.create_category(@valid_attrs)
      assert category.freeminutes == 42
      assert category.name == "some name"
      assert category.ratehour == 120.5
      assert category.raterealtime == 120.5
      assert category.status == "some status"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Space.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Space.update_category(category, @update_attrs)
      assert category.freeminutes == 43
      assert category.name == "some updated name"
      assert category.ratehour == 456.7
      assert category.raterealtime == 456.7
      assert category.status == "some updated status"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Space.update_category(category, @invalid_attrs)
      assert category == Space.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Space.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Space.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Space.change_category(category)
    end
  end

  describe "parkings" do
    alias Parkingappbackend.Space.Parking

    @valid_attrs %{latitude: 120.5, longitude: 120.5, name: "some name", status: "some status", category_id: 1}
    @update_attrs %{latitude: 456.7, longitude: 456.7, name: "some updated name", status: "some updated status", category_id: 1}
    @invalid_attrs %{latitude: nil, longitude: nil, name: nil, status: nil}

    def parking_fixture(attrs \\ %{}) do
      {:ok, parking} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Space.create_parking()

      parking
    end

    test "list_parkings/0 returns all parkings" do
      parking = parking_fixture()
      #assert Space.list_parkings() == [parking]
      assert length(Space.list_parkings()) == 72
    end

    test "get_parking!/1 returns the parking with given id" do
      parking = parking_fixture()
      assert Space.get_parking!(parking.id) == parking
    end

    test "create_parking/1 with valid data creates a parking" do
      assert {:ok, %Parking{} = parking} = Space.create_parking(@valid_attrs)
      assert parking.latitude == 120.5
      assert parking.longitude == 120.5
      assert parking.name == "some name"
      assert parking.status == "some status"
    end

    test "create_parking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Space.create_parking(@invalid_attrs)
    end

    test "update_parking/2 with valid data updates the parking" do
      parking = parking_fixture()
      assert {:ok, %Parking{} = parking} = Space.update_parking(parking, @update_attrs)
      assert parking.latitude == 456.7
      assert parking.longitude == 456.7
      assert parking.name == "some updated name"
      assert parking.status == "some updated status"
    end

    test "update_parking/2 with invalid data returns error changeset" do
      parking = parking_fixture()
      assert {:error, %Ecto.Changeset{}} = Space.update_parking(parking, @invalid_attrs)
      assert parking == Space.get_parking!(parking.id)
    end

    test "delete_parking/1 deletes the parking" do
      parking = parking_fixture()
      assert {:ok, %Parking{}} = Space.delete_parking(parking)
      assert_raise Ecto.NoResultsError, fn -> Space.get_parking!(parking.id) end
    end

    test "change_parking/1 returns a parking changeset" do
      parking = parking_fixture()
      assert %Ecto.Changeset{} = Space.change_parking(parking)
    end
  end
end
