defmodule ZehChallengeWeb.Schema do
  use Absinthe.Schema

  alias ZehChallengeWeb.Resolvers

  import_types(ZehChallengeWeb.Schema.PartnerTypes)

  query do
    @desc "Return a specific partner by its id"
    field :partner, :partner do
      arg(:id, non_null(:id))
      resolve(&Resolvers.PointOfSales.get_partner/3)
    end

    @desc "Search the nearest partner which the coverage area includes the given latitude and longitude"
    field :nearest_partner, :partner do
      arg(:latitude, non_null(:float))
      arg(:longitude, non_null(:float))
      resolve(&Resolvers.PointOfSales.search_nearest_partner/3)
    end
  end

  mutation do
    @desc "Create a partner"
    field :create_partner, type: :partner do
      arg(:trading_name, non_null(:string))
      arg(:owner_name, non_null(:string))
      arg(:document, non_null(:string))
      arg(:coverage_area, non_null(:string))
      arg(:address, non_null(:string))

      resolve(&Resolvers.PointOfSales.create_partner/3)
    end
  end
end
