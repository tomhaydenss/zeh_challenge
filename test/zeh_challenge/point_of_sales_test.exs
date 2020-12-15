defmodule ZehChallenge.PointOfSalesTest do
  use ZehChallenge.DataCase

  alias ZehChallenge.PointOfSales

  describe "partners" do
    alias ZehChallenge.PointOfSales.Partner

    @latitude -43.297337
    @longitude -23.013538
    @valid_attrs %{
      address: "{\"type\":\"Point\",\"coordinates\":[#{@latitude},#{@longitude}]}",
      coverage_area:
        "{\"type\":\"MultiPolygon\",\"coordinates\":[[[[-43.36556,-22.99669],[-43.36539,-23.01928],[-43.26583,-23.01802],[-43.25724,-23.00649],[-43.23355,-23.00127],[-43.2381,-22.99716],[-43.23866,-22.99649],[-43.24063,-22.99756],[-43.24634,-22.99736],[-43.24677,-22.99606],[-43.24067,-22.99381],[-43.24886,-22.99121],[-43.25617,-22.99456],[-43.25625,-22.99203],[-43.25346,-22.99065],[-43.29599,-22.98283],[-43.3262,-22.96481],[-43.33427,-22.96402],[-43.33616,-22.96829],[-43.342,-22.98157],[-43.34817,-22.97967],[-43.35142,-22.98062],[-43.3573,-22.98084],[-43.36522,-22.98032],[-43.36696,-22.98422],[-43.36717,-22.98855],[-43.36636,-22.99351],[-43.36556,-22.99669]]]]}",
      document: "02.453.716/000170",
      owner_name: "Ze da Ambev",
      trading_name: "Adega Osasco"
    }
    @invalid_attrs %{
      address: nil,
      coverage_area: nil,
      document: nil,
      owner_name: nil,
      trading_name: nil
    }

    def partner_fixture(attrs \\ %{}) do
      {:ok, partner} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PointOfSales.create_partner()

      partner
    end

    test "create_partner/1 with valid data creates a partner" do
      assert {:ok, %Partner{} = partner} = PointOfSales.create_partner(@valid_attrs)
      assert partner.address == @valid_attrs.address
      assert partner.coverage_area == @valid_attrs.coverage_area
      assert partner.document == @valid_attrs.document
      assert partner.owner_name == @valid_attrs.owner_name
      assert partner.trading_name == @valid_attrs.trading_name
    end

    test "create_partner/1 with invalid data returns error changeset" do
      assert {:error, changeset} = PointOfSales.create_partner(@invalid_attrs)
      refute changeset.valid?
    end

    test "create_partner/1 with a document already taken returns error changeset" do
      assert {:ok, _first_partner} = PointOfSales.create_partner(@valid_attrs)

      assert {:error, changeset} = PointOfSales.create_partner(@valid_attrs)
      refute changeset.valid?
      assert %{document: ["has already been taken"]} = errors_on(changeset)
    end

    test "get_partner/1 returns the partner with given id" do
      partner = partner_fixture()
      partner_found = PointOfSales.get_partner(partner.id)
      assert partner_found.id == partner.id
      assert partner_found.address == @valid_attrs.address
      assert partner_found.coverage_area == @valid_attrs.coverage_area
      assert partner_found.document == @valid_attrs.document
      assert partner_found.owner_name == @valid_attrs.owner_name
      assert partner_found.trading_name == @valid_attrs.trading_name
    end

    test "get_partner/1 returns nil when an unexistent id was given" do
      unexistent_id = Ecto.UUID.generate()
      assert nil == PointOfSales.get_partner(unexistent_id)
    end

    test "search_nearest_partner/2 returns nearest partner whose coverage area includes the given latitude and longitude" do
      partner = partner_fixture()
      partner_found = PointOfSales.search_nearest_partner(@latitude, @longitude)
      assert partner_found.id == partner.id
      assert partner_found.address == @valid_attrs.address
      assert partner_found.coverage_area == @valid_attrs.coverage_area
      assert partner_found.document == @valid_attrs.document
      assert partner_found.owner_name == @valid_attrs.owner_name
      assert partner_found.trading_name == @valid_attrs.trading_name
    end

    test "search_nearest_partner/2 returns nil when there is no partner that cover a given latitude and longitude" do
      partner_fixture()
      assert nil == PointOfSales.search_nearest_partner(-1000, -1000)
    end
  end
end
