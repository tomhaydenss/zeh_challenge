defmodule ZehChallengeWeb.SchemaTest do
  use ZehChallengeWeb.ConnCase

  alias ZehChallenge.PointOfSales

  @latitude -21.785741
  @longitude -46.57421

  @partner_params %{
    address: "{\"type\":\"Point\",\"coordinates\":[#{@latitude},#{@longitude}]}",
    coverage_area:
      "{\"type\":\"MultiPolygon\",\"coordinates\":[[[[30,20],[45,40],[10,40],[30,20]]],[[[15,5],[40,10],[10,20],[5,10],[15,5]]]]}",
    document: "1432132123891/0001",
    owner_name: "Zé da Silva",
    trading_name: "Adega da Cerveja - Pinheiros"
  }

  @empty_params %{
    address: "",
    coverage_area: "",
    document: "",
    owner_name: "",
    trading_name: ""
  }

  defp fixture(:partner) do
    {:ok, partner} = PointOfSales.create_partner(@partner_params)

    partner
  end

  defp create_partner(_ \\ nil) do
    partner = fixture(:partner)
    %{partner: partner}
  end

  describe "creating a partner" do
    @create_partner_mutation """
    mutation(
        $address: String!
        $coverageArea: String!
        $document: String!
        $ownerName: String!
        $tradingName: String!) {
      createPartner(
        address: $address,
        coverageArea: $coverageArea,
        document: $document,
        ownerName: $ownerName,
        tradingName: $tradingName
      ) {
        id
        ownerName
        tradingName
        document
        address
        coverageArea
      }
    }
    """

    test "successfully", %{conn: conn} do
      body =
        conn
        |> send_create_partner_request(@partner_params)
        |> json_response(200)

      assert %{
               "data" => %{
                 "createPartner" => %{
                   "address" => "{\"type\":\"Point\",\"coordinates\":[-21.785741,-46.57421]}",
                   "coverageArea" =>
                     "{\"type\":\"MultiPolygon\",\"coordinates\":[[[[30,20],[45,40],[10,40],[30,20]]],[[[15,5],[40,10],[10,20],[5,10],[15,5]]]]}",
                   "document" => "1432132123891/0001",
                   "id" => _,
                   "ownerName" => "Zé da Silva",
                   "tradingName" => "Adega da Cerveja - Pinheiros"
                 }
               }
             } = body
    end

    test "with empty fields", %{conn: conn} do
      body =
        conn
        |> send_create_partner_request(@empty_params)
        |> json_response(200)

      assert %{
               "data" => %{"createPartner" => nil},
               "errors" => [
                 %{
                   "changeset" => %{
                     "action" => "insert",
                     "errors" => %{
                       "address" => ["can't be blank"],
                       "coverage_area" => ["can't be blank"],
                       "document" => ["can't be blank"],
                       "owner_name" => ["can't be blank"],
                       "trading_name" => ["can't be blank"]
                     }
                   },
                   "locations" => _,
                   "message" => "Validation failed",
                   "path" => ["createPartner"]
                 }
               ]
             } = body
    end

    test "with a document already taken", %{conn: conn} do
      create_partner()

      body =
        conn
        |> send_create_partner_request(@partner_params)
        |> json_response(200)

      assert %{
               "data" => %{"createPartner" => nil},
               "errors" => [
                 %{
                   "changeset" => %{
                     "action" => "insert",
                     "errors" => %{"document" => ["has already been taken"]}
                   },
                   "locations" => _,
                   "message" => "Validation failed",
                   "path" => ["createPartner"]
                 }
               ]
             } = body
    end

    defp send_create_partner_request(conn, params) do
      post(conn, "/api/graphql", %{
        "query" => @create_partner_mutation,
        "variables" => %{
          address: params.address,
          coverageArea: params.coverage_area,
          document: params.document,
          ownerName: params.owner_name,
          tradingName: params.trading_name
        }
      })
    end
  end

  describe "querying a partner" do
    @partner_query """
    query($id: ID!) {
      partner(id: $id) {
        id
        ownerName
        tradingName
        document
        address
        coverageArea
      }
    }
    """

    setup [:create_partner]

    test "successfully", %{conn: conn, partner: partner} do
      body =
        conn
        |> send_get_partner_request(partner.id)
        |> json_response(200)

      assert body == %{
               "data" => %{
                 "partner" => %{
                   "address" => @partner_params.address,
                   "coverageArea" => @partner_params.coverage_area,
                   "document" => @partner_params.document,
                   "id" => partner.id,
                   "ownerName" => @partner_params.owner_name,
                   "tradingName" => @partner_params.trading_name
                 }
               }
             }
    end

    test "not found", %{conn: conn} do
      body =
        conn
        |> send_get_partner_request("D4C1C485-8093-4998-9346-CAFD5C0DF5BB")
        |> json_response(200)

      assert %{
               "data" => %{"partner" => nil},
               "errors" => [
                 %{
                   "locations" => _,
                   "message" => "Partner ID D4C1C485-8093-4998-9346-CAFD5C0DF5BB not found",
                   "path" => ["partner"]
                 }
               ]
             } = body
    end

    defp send_get_partner_request(conn, id) do
      post(conn, "/api/graphql", %{
        "query" => @partner_query,
        "variables" => %{id: id}
      })
    end
  end

  describe "searching nearest partner" do
    @nearest_partner_query """
    query($latitude: Float!, $longitude: Float!) {
      nearestPartner(latitude: $latitude, longitude: $longitude) {
        id
        ownerName
        tradingName
        document
        address
        coverageArea
      }
    }
    """

    setup [:create_partner]

    test "successfully", %{conn: conn, partner: partner} do
      body =
        conn
        |> send_nearest_partner_request(@latitude, @longitude)
        |> json_response(200)

      assert body == %{
               "data" => %{
                 "nearestPartner" => %{
                   "address" => @partner_params.address,
                   "coverageArea" => @partner_params.coverage_area,
                   "document" => @partner_params.document,
                   "id" => partner.id,
                   "ownerName" => @partner_params.owner_name,
                   "tradingName" => @partner_params.trading_name
                 }
               }
             }
    end

    test "without result", %{conn: conn} do
      body =
        conn
        |> send_nearest_partner_request(-12345.6, -12345.6)
        |> json_response(200)

      assert %{
               "data" => %{"nearestPartner" => nil},
               "errors" => [
                 %{
                   "locations" => _,
                   "message" =>
                     "Partner whose coverage area includes longitude -12345.6 and latitude -12345.6 could not be found",
                   "path" => ["nearestPartner"]
                 }
               ]
             } = body
    end

    defp send_nearest_partner_request(conn, latitude, longitude) do
      post(conn, "/api/graphql", %{
        "query" => @nearest_partner_query,
        "variables" => %{latitude: latitude, longitude: longitude}
      })
    end
  end
end
