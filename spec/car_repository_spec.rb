require 'car_repository'
require 'json'
require 'rspec'

RSpec.describe CarRepository do
  it "should successfully connect to the database and find 10 cars" do
    repo = CarRepository.new()
    car_data = JSON.parse(repo.find_cars_by_geocoord(GeoCoord.new("12.2,13.3")))
    expect(car_data['cars'].length).to eq 10
  end
end

