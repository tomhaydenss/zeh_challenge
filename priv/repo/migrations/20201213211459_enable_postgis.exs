defmodule ZehChallenge.Repo.Migrations.EnablePostgis do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
  end
end
