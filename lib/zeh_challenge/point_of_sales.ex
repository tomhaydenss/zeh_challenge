defmodule ZehChallenge.PointOfSales do
  import Ecto.Query, warn: false
  import Geo.PostGIS
  alias ZehChallenge.Repo

  alias ZehChallenge.PointOfSales.Partner

  def create_partner(attrs \\ %{}) do
    %Partner{}
    |> Partner.changeset(attrs)
    |> Repo.insert()
  end

  def get_partner(id) do
    from(partner in Partner, where: partner.id == ^id)
    |> apply_computed_fields()
    |> Repo.one()
  end

  @default_precision 1000.0
  def search_nearest_partner(longitude, latitude) do
    point = %Geo.Point{coordinates: {longitude, latitude}}

    from(partner in Partner,
      where: st_dwithin(partner.coverage_area_geom, ^point, ^@default_precision),
      order_by: st_distance(partner.coverage_area_geom, ^point),
      limit: 1
    )
    |> apply_computed_fields()
    |> Repo.one()
  end

  defp apply_computed_fields(query) do
    select_merge(query, [partner], %{
      address: fragment("ST_AsGeoJSON(?)", partner.address_geom),
      coverage_area: fragment("ST_AsGeoJSON(?)", partner.coverage_area_geom)
    })
  end
end
