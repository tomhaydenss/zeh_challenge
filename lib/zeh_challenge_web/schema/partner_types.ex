defmodule ZehChallengeWeb.Schema.PartnerTypes do
  use Absinthe.Schema.Notation

  object :partner do
    field(:id, :id)
    field(:trading_name, :string)
    field(:owner_name, :string)
    field(:document, :string)
    field(:coverage_area, :string)
    field(:address, :string)
  end
end
