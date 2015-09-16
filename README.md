This example was realized using Ruby, Sinatra, RSpec for unit tests and PostgreSQL 9.4. The choice of not using an ORM was deliberate for various reasons:
- There's no business logic on the Ruby side, so no need for a strong model
- By using Postgres' JSONB type we don't have a static schema
- No mapping, serialization, and deserialization is needed. By directly storing JSON in the database all we need to do is passing it through. 

As a matter-of-fact, the CarRepository knows nothing about cars and acts more as a spatial-enabled JSON store. If we need a strong domain-model later-on the mapping to POROs can be done in a second step.

## Run instructions

### By using Docker (aka the simple way)

- Install [Docker](https://docs.docker.com/installation/) and [Docker Compose](https://docs.docker.com/compose/install/). If you're on Windows or Mac OSX go directly for the [Docker Toolbox](https://www.docker.com/toolbox).
- Clone this repository and cd into it.
- Initialize the database by running ``` docker-compose run car_api rake db:init```. Lots of things are happening here on the first run, so be a little patient.
- Run the tests by running ``` docker-compose run car_api rake spec```
- If you're patient, run the benchmark by running ``` docker-compose run car_api rake spec:benchmark```
- Seed the database with the data provided in data.json by running ``` docker-compose run car_api rake db:seed```
- Start the API with ``` docker-compose up -d car_api```

If you used the Docker Toolbox the API should now be available under http://192.168.99.100:5000/cars
If you are on Linux, it's available under http://localhost:5000/cars

### The classic way

You need to:
- provide an instance of Postgres >= 9.4 with Postgis extensions enabled. Version 9.4 is mandatory since we use the JSONB datatype.
- export the following environment variables
  - POSTGIS_PORT_5432_TCP_ADDR
  - POSTGIS_PORT_5432_TCP_PORT if not 5432
  - PGUSER if not postgres
  - PGPASSWORD
  - RACK_ENV=production if you want the production enviroement
- Install the dependencies by running ``` bundle install ```
- Initialize the database by running ``` rake db:init```
- Run the tests by running ``` rake spec```
- If you're patient, run the benchmark by running ``` rake spec:benchmark```
- Seed the database with the data provided in data.json by running ``` rake db:seed```
- Start the API with ``` rake ```

The API is now available under http://localhost:5000/cars

# Cars API
As an extension to our current backend infrastructure, we decided to create a car-sharing API to help us to show the best options around an user’s position.

In order to show cars on a map, all we need is a name, description and position of the vehicle. And it is up to the api to organize different data sources and provide a single response via an endpoint.

## Instructions

In this exercise, your job is to build a simple API/webservice that expose one single endpoint called `/cars` that receives a GET with the location parameter as the example below:

GET /cars?location=51.5444204,-0.22707

This endpoint should fetch the 10 closest cars from the database and return them ordered by distance from the point receive. See the following snippet of a valid response:

````json
{
    "cars": [
      {
        "description": "West Ealing - Hartington Rd",
        "latitude": 51.511318,
        "longitude": -0.318178
      },
      {
        "description": "Sudbury - Williams Way",
        "latitude": 51.553667,
        "longitude": -0.315159
      },
      {
        "description": "West Ealing - St Leonard’s Rd",
        "latitude": 51.512107,
        "longitude": -0.313599
      }
    ]
}
````

- You can use the file `data.json` as seed for your database
- We suggest you to save this content in a database, so you can sort and filter them easily.
- The endpoint should return the correct status codes for a success request and a failed one.
- Use this repository to build your solution.
- The solution should perform well regardless of the number of records
- Don't forget the instructions for testing and running the code.
