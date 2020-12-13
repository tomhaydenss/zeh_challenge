defmodule ZehChallenge.Repo do
  use Ecto.Repo,
    otp_app: :zeh_challenge,
    adapter: Ecto.Adapters.Postgres
end
