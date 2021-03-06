defmodule ParkingappbackendWeb.SearchView do
  use ParkingappbackendWeb, :view
  alias ParkingappbackendWeb.SearchView


  def render("index.json", %{search: search}) do
    render_many(search, SearchView, "parking.json")
  end

  def render("parking.json", %{search: search}) do

    {id, name, latitude , longitude , status,catname, ratehour,raterealtime,freeminutes} = search
    %{id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      status: status,
      catname: catname,
      ratehour: ratehour,
      raterealtime: raterealtime,
      freeminutes: freeminutes
    }
  end

  def render("fees.json", %{search: search}) do

    {id, name, latitude , longitude , status,catname, ratehour,raterealtime,freeminutes,fees_real , fees_hour} = search
    %{id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      status: status,
      catname: catname,
      ratehour: ratehour,
      raterealtime: raterealtime,
      freeminutes: freeminutes,
      fees_real: fees_real,
      fees_hour: fees_hour
    }
  end

end
