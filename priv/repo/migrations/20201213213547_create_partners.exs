defmodule ZehChallenge.Repo.Migrations.CreatePartners do
  use Ecto.Migration

  def change do
    create table(:partners, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :trading_name, :string
      add :owner_name, :string
      add :document, :string
      add :coverage_area_geom, :geometry
      add :address_geom, :geometry

      timestamps()
    end

    create unique_index(:partners, [:document])
    create index(:partners, [:coverage_area_geom], using: :gist)
  end
end
