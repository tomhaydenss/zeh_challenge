defmodule ZehChallenge.PointOfSales.Partner do
  import Ecto.Changeset
  use Ecto.Schema
  alias ZehChallenge.StringUtil

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "partners" do
    field :address, :string, virtual: true
    field :address_geom, Geo.PostGIS.Geometry
    field :coverage_area, :string, virtual: true
    field :coverage_area_geom, Geo.PostGIS.Geometry
    field :document, :string
    field :owner_name, :string
    field :trading_name, :string

    timestamps()
  end

  @doc false
  def changeset(partner, attrs) do
    partner
    |> cast(attrs, [:trading_name, :owner_name, :document, :coverage_area, :address])
    |> validate_required([:trading_name, :owner_name, :document, :coverage_area, :address])
    |> unique_constraint(:document, name: :partners_document_index)
    |> cast_address_geom()
    |> cast_coverage_area_geom()
  end

  defp cast_address_geom(changeset) do
    address = get_change(changeset, :address)

    if StringUtil.blank?(address) do
      changeset
    else
      {:ok, address_geom} = Geo.PostGIS.Geometry.cast(address)
      put_change(changeset, :address_geom, address_geom)
    end
  end

  defp cast_coverage_area_geom(changeset) do
    coverage_area = get_change(changeset, :coverage_area)

    if StringUtil.blank?(coverage_area) do
      changeset
    else
      {:ok, coverage_area_geom} = Geo.PostGIS.Geometry.cast(coverage_area)
      put_change(changeset, :coverage_area_geom, coverage_area_geom)
    end
  end
end
