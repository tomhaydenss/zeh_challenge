Postgrex.Types.define(
  ZehChallenge.PostgisTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
