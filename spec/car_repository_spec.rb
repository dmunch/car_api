require 'car_repository'
require 'json'
require 'rspec'
require 'haversine'


RSpec.describe CarRepository do
  it "should successfully connect to the database and find 10 cars" do
    repo = CarRepository.new()
    car_data = JSON.parse(repo.find_cars_by_geocoord(GeoCoord.new("12.2,13.3")))
    expect(car_data['cars'].length).to eq 10
  end

  it "should order results descending by euclidian distance relative to query point" do
    repo = CarRepository.new()
    car_data = JSON.parse(repo.find_cars_by_geocoord(GeoCoord.new("12.2,13.3")))
    
    #This metric is for Haversine distance. However, due to lack of specification we settle with euclidian distance.
    #metric = lambda {|lat, long, car| Haversine.distance(lat, long, car['latitude'], car['longitude']).to_km }
    
    metric = lambda {|lat, long, car| Math.sqrt((lat- car['latitude'])**2 + (long - car['longitude'])**2) }

    cars = car_data['cars']
    distances = cars.map{ |car| metric.call(12.2, 13.3, car) }
    expect(distances.each_cons(2).all?{|i,j| i <= j}).to be_truthy
  end
  
end

