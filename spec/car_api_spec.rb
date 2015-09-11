ENV['RACK_ENV'] = 'test'

require 'car_api' 
require 'rspec'
require 'rack/test'

RSpec.describe "car_api" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
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
end
