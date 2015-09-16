DROP DATABASE IF EXISTS car_api;
CREATE DATABASE car_api;
\c car_api
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
CREATE TABLE car_data(car_data JSONB);

CREATE OR REPLACE FUNCTION json_to_point(data JSONB)
RETURNS geometry AS $$
BEGIN
  RETURN ST_SetSRID(ST_Point((data->>'longitude')::float, (data->>'latitude')::float), 4326);
END
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

CREATE INDEX point_idx ON car_data USING GIST(json_to_point(car_data));
