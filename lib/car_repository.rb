require 'pg'
require 'geocoord'

class CarRepository
  def initialize()
    @conn = PGconn.connect('192.168.99.100', 5432, '', '', "car_api", "postgres", "mysecretpassword")
    query_car_data_sql = %{
      SELECT car_data FROM car_data 
      --Note: ST_Point takes coordinate in lon, lat, our convention is lat, lon that's why we inverse here
      ORDER BY ST_SetSRID(ST_Point((car_data->>'latitude')::float, (car_data->>'longitude')::float), 4326)  <-> ST_SetSRID(ST_Point($2, $1), 4326)
			LIMIT 10
    }
    query_car_data_json_sql = %{SELECT json_build_object('cars', json_agg(car_data)) as cars FROM (#{query_car_data_sql}) sub }

    @conn.prepare('query_car_data', query_car_data_sql); 
    @conn.prepare('query_car_data_json', query_car_data_json_sql); 
    @conn.prepare('insert_car_data', 'INSERT INTO car_data(car_data) VALUES ($1)')
  end

  def find_cars_by_geocoord(coord)
    @conn.exec_prepared('query_car_data_json', [coord.lat, coord.long])[0]['cars']
  end

  def insert(car_data)
    #make sure we have at least lat and long
    raise ArgumentError.new("car_data needs to have a field latitude") unless car_data['latitude']
    raise ArgumentError.new("car_data needs to have a field longitude") unless car_data['longitude']
	 
    #make sure lat and long are in float 
	  car_data['latitude'] = car_data['latitude'].to_f
	  car_data['longitude'] = car_data['longitude'].to_f
    
    @conn.exec_prepared('insert_car_data', [JSON.generate(car_data)]);
  end
  
  def delete_all()
    @conn.exec('DELETE FROM car_data')
  end
end