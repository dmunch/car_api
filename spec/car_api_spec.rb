ENV['RACK_ENV'] = 'test'

require 'car_api' 
require 'rspec'
require 'rack/test'

describe "car_api" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "refuses requests without location parameter with http status 400, bad request" do
    get '/cars'
    #expect(last_response).to be_ok 
    expect(last_response.status).to eq 400 
  end
  
  it "refuses requests without location parameter with approbiate error message" do
    get '/cars'
    expect(last_response.body).to eq "location parameter missing" 
  end
  
  it "refuses requests with malformed location parameter with http status 400, bad request" do
    get '/cars?location=12.3,'
    expect(last_response.status).to eq 400 
  end
  it "refuses requests with malformed location parameter with approbiate error message" do
    get '/cars?location=12.3,'
    expect(last_response.body).to eq "location parameter malformed" 
  end
end
