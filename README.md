# zeh |> challenge()

This is a backend application created aimed to fulfill the following challenge: [Zé Delivery - Backend Challenge](https://github.com/ZXVentures/ze-code-challenges/blob/master/backend.md)

## Configuring local environment

In order to run the application locally or to run the test suite you must setup your local environment following the instructions bellow.

First we need to build our Docker image:

    $ docker-compose build

After that we need to create and migrate the database (it should be executed once):

    $ docker-compose run zeh_challenge_api mix ecto.setup

For the test environment, the `-e MIX_ENV=test` parameter shall be passed:

    $ docker-compose run -e MIX_ENV=test zeh_challenge_api mix ecto.setup

## Running the test suite

In order to run the test suite, just run the command bellow:

    $ docker-compose run -e MIX_ENV=test zeh_challenge_api mix test

## Running application locally

Running application

    $ docker-compose up

Now we can visit [ `localhost:4000/api/graphiql` ](http://localhost:4000/api/graphiql) from a browser to access GraphiQL Workspace.
The GraphiQL Workspace is GUI where we can edit and test GraphQL queries and mutations.

## Testing the GraphQL APIs

Once the applications is up and running, we can try the partner APIs.

### Create Partner Mutation

In order to create a partner, we can use the following mutation as example:

``` graphql
mutation {
  createPartner(
    tradingName: "Adega Sao Paulo",
    ownerName: "Pedro Silva",
    document: "04666182390",
    coverageArea: "{ \"type\": \"MultiPolygon\", \"coordinates\": [ [ [ [ -38.6577, -3.7753 ], [ -38.63212, -3.81418 ], [ -38.61925, -3.82873 ], [ -38.59762, -3.84004 ], [ -38.58727, -3.84345 ], [ -38.58189, -3.8442 ], [ -38.57667, -3.84573 ], [ -38.56706, -3.85015 ], [ -38.56637, -3.84937 ], [ -38.56268, -3.84286 ], [ -38.56148, -3.83772 ], [ -38.55881, -3.82411 ], [ -38.55577, -3.81507 ], [ -38.55258, -3.80674 ], [ -38.54968, -3.80222 ], [ -38.53406, -3.79495 ], [ -38.52894, -3.77718 ], [ -38.52517, -3.76313 ], [ -38.53118, -3.76203 ], [ -38.53968, -3.76126 ], [ -38.54577, -3.76151 ], [ -38.55344, -3.76102 ], [ -38.56327, -3.76029 ], [ -38.58118, -3.75907 ], [ -38.60079, -3.75423 ], [ -38.60671, -3.74772 ], [ -38.61787, -3.7431 ], [ -38.62577, -3.7472 ], [ -38.63332, -3.7496 ], [ -38.65049, -3.76057 ], [ -38.6577, -3.7753 ] ] ] ] }",
    address: "{ \"type\": \"Point\", \"coordinates\": [ -38.59826, -3.774186 ] }"
  ) {
    id
      ownerName
      tradingName
      document
      address
      coverageArea
  }
}
```

Or if wish to test with command line, you can try:

    $ curl -L -X POST 'http://localhost:4000/api/graphql' -H 'Content-Type: application/json' --data-raw '{"query":"mutation {\n  createPartner(\n    tradingName: \"Adega Sao Paulo\", \n    ownerName: \"Pedro Silva\", \n    document: \"04666182390\", \n    coverageArea: \"{ \\\"type\\\": \\\"MultiPolygon\\\", \\\"coordinates\\\": [ [ [ [ -38.6577, -3.7753 ], [ -38.63212, -3.81418 ], [ -38.61925, -3.82873 ], [ -38.59762, -3.84004 ], [ -38.58727, -3.84345 ], [ -38.58189, -3.8442 ], [ -38.57667, -3.84573 ], [ -38.56706, -3.85015 ], [ -38.56637, -3.84937 ], [ -38.56268, -3.84286 ], [ -38.56148, -3.83772 ], [ -38.55881, -3.82411 ], [ -38.55577, -3.81507 ], [ -38.55258, -3.80674 ], [ -38.54968, -3.80222 ], [ -38.53406, -3.79495 ], [ -38.52894, -3.77718 ], [ -38.52517, -3.76313 ], [ -38.53118, -3.76203 ], [ -38.53968, -3.76126 ], [ -38.54577, -3.76151 ], [ -38.55344, -3.76102 ], [ -38.56327, -3.76029 ], [ -38.58118, -3.75907 ], [ -38.60079, -3.75423 ], [ -38.60671, -3.74772 ], [ -38.61787, -3.7431 ], [ -38.62577, -3.7472 ], [ -38.63332, -3.7496 ], [ -38.65049, -3.76057 ], [ -38.6577, -3.7753 ] ] ] ] }\", \n    address: \"{ \\\"type\\\": \\\"Point\\\", \\\"coordinates\\\": [ -38.59826, -3.774186 ] }\"\n  ) {\n    id\n      ownerName\n      tradingName\n      document\n      address\n      coverageArea\n  }\n}", "variables":{}}'

Both ways should return a result like this:

``` json
{
  "data": {
    "createPartner": {
      "address": "{ \"type\": \"Point\", \"coordinates\": [ -38.59826, -3.774186 ] }",
      "coverageArea": "{ \"type\": \"MultiPolygon\", \"coordinates\": [ [ [ [ -38.6577, -3.7753 ], [ -38.63212, -3.81418 ], [ -38.61925, -3.82873 ], [ -38.59762, -3.84004 ], [ -38.58727, -3.84345 ], [ -38.58189, -3.8442 ], [ -38.57667, -3.84573 ], [ -38.56706, -3.85015 ], [ -38.56637, -3.84937 ], [ -38.56268, -3.84286 ], [ -38.56148, -3.83772 ], [ -38.55881, -3.82411 ], [ -38.55577, -3.81507 ], [ -38.55258, -3.80674 ], [ -38.54968, -3.80222 ], [ -38.53406, -3.79495 ], [ -38.52894, -3.77718 ], [ -38.52517, -3.76313 ], [ -38.53118, -3.76203 ], [ -38.53968, -3.76126 ], [ -38.54577, -3.76151 ], [ -38.55344, -3.76102 ], [ -38.56327, -3.76029 ], [ -38.58118, -3.75907 ], [ -38.60079, -3.75423 ], [ -38.60671, -3.74772 ], [ -38.61787, -3.7431 ], [ -38.62577, -3.7472 ], [ -38.63332, -3.7496 ], [ -38.65049, -3.76057 ], [ -38.6577, -3.7753 ] ] ] ] }",
      "document": "04666182390",
      "id": "0cd1d600-5d7e-446e-b7a5-36b9bb0d6316",
      "ownerName": "Pedro Silva",
      "tradingName": "Adega Sao Paulo"
    }
  }
}
```

### Query Partner by ID

In order to query a partner by its ID, we can use the following example (don't forget to use a valid partner id):

``` graphql
{
  partner(id: "0cd1d600-5d7e-446e-b7a5-36b9bb0d6316") {
    id
    ownerName
    tradingName
    document
    address
    coverageArea
  }
}
```

The command line version for this query is:

    $ curl -L -X POST 'http://localhost:4000/api/graphql' -H 'Content-Type: application/json' --data-raw '{"query":"{\n  partner(id: \"0cd1d600-5d7e-446e-b7a5-36b9bb0d6316\") {\n    id\n    ownerName\n    tradingName\n    document\n    address\n    coverageArea\n  }\n}", "variables":{}}'

And the query result should be something like that:

``` json
{
  "data": {
    "partner": {
      "address": "{\"type\":\"Point\",\"coordinates\":[-38.59826,-3.774186]}",
      "coverageArea": "{\"type\":\"MultiPolygon\",\"coordinates\":[[[[-38.6577,-3.7753],[-38.63212,-3.81418],[-38.61925,-3.82873],[-38.59762,-3.84004],[-38.58727,-3.84345],[-38.58189,-3.8442],[-38.57667,-3.84573],[-38.56706,-3.85015],[-38.56637,-3.84937],[-38.56268,-3.84286],[-38.56148,-3.83772],[-38.55881,-3.82411],[-38.55577,-3.81507],[-38.55258,-3.80674],[-38.54968,-3.80222],[-38.53406,-3.79495],[-38.52894,-3.77718],[-38.52517,-3.76313],[-38.53118,-3.76203],[-38.53968,-3.76126],[-38.54577,-3.76151],[-38.55344,-3.76102],[-38.56327,-3.76029],[-38.58118,-3.75907],[-38.60079,-3.75423],[-38.60671,-3.74772],[-38.61787,-3.7431],[-38.62577,-3.7472],[-38.63332,-3.7496],[-38.65049,-3.76057],[-38.6577,-3.7753]]]]}",
      "document": "04666182390",
      "id": "0cd1d600-5d7e-446e-b7a5-36b9bb0d6316",
      "ownerName": "Pedro Silva",
      "tradingName": "Adega Sao Paulo"
      }
  }
}
```

### Query Nearest Partner by Latitude and Longitude

Last but not least, we can query the nearest partner for a given latitude and longitude pair following the example bellow:

``` graphql
{
  nearestPartner(
    latitude: -38.59826,
    longitude: -3.774186
  ) {
    id
    ownerName
    tradingName
    document
    address
    coverageArea
  }
}
```

The command line version for this query is:

    $ curl -L -X POST 'http://localhost:4000/api/graphql' -H 'Content-Type: application/json' --data-raw '{"query":"{\n  nearestPartner(\n    latitude: -38.59826,\n    longitude: -3.774186\n  ) {\n    id\n    ownerName\n    tradingName\n    document\n    address\n    coverageArea\n  }\n}","variables":{}}'

And the query result should be something like that:

``` json
{
  "data": {
    "nearestPartner": {
      "address": "{\"type\":\"Point\",\"coordinates\":[-38.59826,-3.774186]}",
      "coverageArea": "{\"type\":\"MultiPolygon\",\"coordinates\":[[[[-38.6577,-3.7753],[-38.63212,-3.81418],[-38.61925,-3.82873],[-38.59762,-3.84004],[-38.58727,-3.84345],[-38.58189,-3.8442],[-38.57667,-3.84573],[-38.56706,-3.85015],[-38.56637,-3.84937],[-38.56268,-3.84286],[-38.56148,-3.83772],[-38.55881,-3.82411],[-38.55577,-3.81507],[-38.55258,-3.80674],[-38.54968,-3.80222],[-38.53406,-3.79495],[-38.52894,-3.77718],[-38.52517,-3.76313],[-38.53118,-3.76203],[-38.53968,-3.76126],[-38.54577,-3.76151],[-38.55344,-3.76102],[-38.56327,-3.76029],[-38.58118,-3.75907],[-38.60079,-3.75423],[-38.60671,-3.74772],[-38.61787,-3.7431],[-38.62577,-3.7472],[-38.63332,-3.7496],[-38.65049,-3.76057],[-38.6577,-3.7753]]]]}",
      "document": "04666182390",
      "id": "0cd1d600-5d7e-446e-b7a5-36b9bb0d6316",
      "ownerName": "Pedro Silva",
      "tradingName": "Adega Sao Paulo"
    }
  }
}
```
