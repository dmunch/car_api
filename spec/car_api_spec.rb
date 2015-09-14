ENV['RACK_ENV'] = 'test'

require 'car_api' 
require 'rspec'
require 'rack/test'

RSpec.describe "car_api" do
  include Rack::Test::Methods

  def app
    CarApi.new(nil, repository_class) 
  end
  let(:repository) { double("car_repository") }
  let(:repository_class) { class_double("car_repository_type") }

  it "calls close after the end of the request" do
    expect(repository_class).to receive(:use).and_return(repository)
    
    get '/cars?location=12.3,14.4'
  end
  
  context "not given a location parameter" do
    it "refuses request with http status 400, bad request" do
      get '/cars'
      expect(last_response.status).to eq 400 
    end
    
    it "refuses requests approbiate error message" do
      get '/cars'
      expect(last_response.body).to eq "location parameter missing" 
    end
  end  
  
  context "given a malformed location parameter" do
    it "refuses requests with http status 400, bad request" do
      get '/cars?location=12.3,'
      expect(last_response.status).to eq 400 
    end
    it "refuses requests approbiate error message" do
      get '/cars?location=12.3,'
      expect(last_response.body).to eq "Invalid coordinate string format" 
    end
  end
  
  context "given a valid location parameter" do
    it "accepts requests with http status 200, OK" do
      expect(repository_class).to receive(:use).and_return(repository)
      
      get '/cars?location=12.3,14.4'
      expect(last_response.status).to eq 200 
    end
    it "returns content_type JSON" do
      expect(repository_class).to receive(:use).and_return(repository)
      
      get '/cars?location=12.3,14.4'
      expect(last_response.content_type).to eq "application/json" 
    end
    it "calls repositories's find_cars_by_geocoord with correct parameter" do
      expect(repository_class).to receive(:use).with(any_args).and_yield(repository)
      expect(repository).to receive(:find_cars_by_geocoord).with(GeoCoord.new("12.3,14.4"))
      
      get '/cars?location=12.3,14.4'
    end
    it "returns the return value of repositorie's find_cars_by_geocoord" do
      expect(repository_class).to receive(:use).with(any_args).and_yield(repository)
      expect(repository).to receive(:find_cars_by_geocoord).with(any_args).and_return("OK")
      
      get '/cars?location=12.3,14.4'
      expect(last_response.body).to eq "OK" 
    end
  end
end
