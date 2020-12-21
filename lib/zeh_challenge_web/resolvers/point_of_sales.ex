defmodule ZehChallengeWeb.Resolvers.PointOfSales do
  alias ZehChallenge.PointOfSales

  def get_partner(_parent, %{id: id}, _resolution) do
    with {:ok, uuid} <- Ecto.UUID.cast(id) do
      case PointOfSales.get_partner(uuid) do
        nil ->
          {:error, "Partner ID #{id} not found"}

        partner ->
          {:ok, partner}
      end
    else
      :error ->
        {:error, "Invalid value for the given Partner ID"}
    end
  end

  def create_partner(_parent, args, _resolution) do
    case PointOfSales.create_partner(args) do
      {:ok, partner} ->
        {:ok, partner}

      error = {:error, _} ->
        parse_response(error)
    end
  end

  def search_nearest_partner(_parent, %{latitude: latitude, longitude: longitude}, _resolution) do
    case PointOfSales.search_nearest_partner(longitude, latitude) do
      nil ->
        {:error,
         "Partner whose coverage area includes longitude #{longitude} and latitude #{latitude} could not be found"}

      partner ->
        {:ok, partner}
    end
  end

  defp parse_response({:error, changeset = %Ecto.Changeset{}}) do
    {:error,
     message: "Validation failed",
     changeset: %{
       errors:
         Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
           Enum.reduce(opts, msg, fn {key, value}, acc ->
             if is_binary(value) do
               String.replace(acc, "%{#{key}}", value)
             else
               acc
             end
           end)
         end),
       action: changeset.action
     }}
  end
end
