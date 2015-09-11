DROP DATABASE IF EXISTS car_api;
CREATE DATABASE car_api;
\c car_api
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
CREATE TABLE car_data(car_data JSONB);
CREATE INDEX point_idx ON car_data USING GIST(ST_SetSRID(ST_Point((car_data->>'latitude')::float, (car_data->>'longitude')::float), 4326));
