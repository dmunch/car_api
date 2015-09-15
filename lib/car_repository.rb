require 'pg'
require 'geocoord'
require 'connection_pool'

class CarRepository
  @@n = 10
  @@number_of_connections_in_pool = 5 
  @@pool = ConnectionPool.new(size: @@number_of_connections_in_pool, timeout: 10) { connect() } 
  def self.use(*args)
    @@pool.with do |conn|
      yield handle = new(conn, *args)
    end
  ensure
    #connection is checked in by connection pool 
  end
  
  def self.connect()
    conn = PGconn.connect('192.168.99.100', 5432, '', '', "car_api", "postgres", "mysecretpassword") 
    
    query_car_data_sql = %{
      SELECT car_data FROM car_data 
      --Note: ST_Point takes coordinate in lon, lat, our convention is lat, lon that's why we inverse here
      ORDER BY ST_SetSRID(ST_Point((car_data->>'longitude')::float, (car_data->>'latitude')::float), 4326) <-> ST_SetSRID(ST_Point($2, $1), 4326)
      --This one is for Haversine distance. However, due to lack of specification we settle with euclidian distance.
      --ORDER BY ST_Distance(Geography(ST_SetSRID(ST_Point((car_data->>'longitude')::float, (car_data->>'latitude')::float), 4326)), Geography(ST_SetSRID(ST_Point($2, $1), 4326)))
			LIMIT 10
    }
    query_car_data_json_sql = %{SELECT json_build_object('cars', json_agg(car_data)) as cars FROM (#{query_car_data_sql}) sub }

    conn.prepare('query_car_data', query_car_data_sql); 
    conn.prepare('query_car_data_json', query_car_data_json_sql); 
    conn.prepare('insert_car_data', 'INSERT INTO car_data(car_data) VALUES ($1)')
    conn
  end 
  
  def initialize(conn)
    @conn = conn
  end

  def find_cars_by_geocoord(coord)
    @conn.exec_prepared('query_car_data_json', [coord.lat, coord.long])[0]['cars']
  end
  def find_cars_by_coords(lat, long)
    @conn.exec_prepared('query_car_data_json', [lat, long])[0]['cars']
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

  def num_connections
    @conn.exec('SELECT sum(numbackends) AS numbackends FROM pg_stat_database;')[0]['numbackends'].to_i
  end
end
