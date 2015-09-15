require 'car_repository'
require 'json'
require 'rspec'
require 'haversine'
require 'random-location'
require 'benchmark'

RSpec.describe CarRepository do
  it "should successfully connect to the database and find 10 cars" do
    CarRepository.use() do |repo|
      #setup test data
      repo.delete_all()
      (0..20).each do |i|
        random_coord = RandomLocation.near_by(52.4699221,13.4373798, 100000)
        repo.insert({'latitude' => random_coord[0], 'longitude' => random_coord[1], 'descr' => i})
      end
      
      car_data = JSON.parse(repo.find_cars_by_geocoord(GeoCoord.new("12.2,13.3")))
      expect(car_data['cars'].length).to eq 10
    end
  end

  it "should order results descending by euclidian distance relative to query point" do
    CarRepository.use() do |repo|
      #setup test data
      repo.delete_all()
      (0..20).each do |i|
        random_coord = RandomLocation.near_by(52.4699221,13.4373798, 100000)
        repo.insert({'latitude' => random_coord[0], 'longitude' => random_coord[1], 'descr' => i})
      end
      
      car_data = JSON.parse(repo.find_cars_by_geocoord(GeoCoord.new("12.2,13.3")))
      
      #This metric is for Haversine distance. However, due to lack of specification we settle with euclidian distance.
      #metric = lambda {|lat, long, car| Haversine.distance(lat, long, car['latitude'], car['longitude']).to_km }
      
      metric = lambda {|lat, long, car| Math.sqrt((lat- car['latitude'])**2 + (long - car['longitude'])**2) }

      cars = car_data['cars']
      distances = cars.map{ |car| metric.call(12.2, 13.3, car) }
      expect(distances.each_cons(2).all?{|i,j| i <= j}).to be_truthy
    end
  end
 
  it "should find the 10 nearest cars relative to given location" do
    CarRepository.use() do |repo|
      #setup test data
      repo.delete_all()

      test_lats = [12.2, 13.3, 144.4, 155.5]
      test_longs = [13.3, 12.2, 155.5, 144.4]
    
      coords_with_index = test_lats.zip(test_longs).to_enum.with_index
      
      coords_with_index.each do |coord, i|
        (0..20).each do |rep|
          random_coord = RandomLocation.near_by(coord[0], coord[1], 10000)
          repo.insert({'latitude' => random_coord[0], 'longitude' => random_coord[1], 'descr' => i})
        end
      end 
      
      coords_with_index.each do |coord, i|
        cars = JSON.parse(repo.find_cars_by_coords(coord[0], coord[1]))['cars']
        expect(cars.all?{|c| c['descr'] == i}).to be_truthy 
      end
    end
  end
  it "should reuse connections in pool" do
    #create 100 instances of repo
    (0..100).each{ CarRepository.use() { |repo| }}
   
    #number of connections should still be 1
    CarRepository.use() do |repo|
      expect(repo.num_connections).to eq(1)
    end 
  end
  it "should be fast, independently of the number of cars", :benchmark => true do
    CarRepository.use() do |repo|
      repo.delete_all()

      number_of_data_sets = 200000
      puts "Building up data for benchmark (#{number_of_data_sets}), this can take a while..." 
      (0..number_of_data_sets).each do |i|
        random_coord = RandomLocation.near_by(52.4699221,13.4373798, 10000000)
        repo.insert({'latitude' => random_coord[0], 'longitude' => random_coord[1], 'descr' => i})
      
        puts "..(#{i})" unless i.modulo(10000) != 0
      end
      
      expect(Benchmark.realtime{ repo.find_cars_by_coords(52.4699221,13.4373798) }).to be <= 2
    end
  end
end 
