require 'sinatra'
require 'geocoord'

class CarApi < Sinatra::Base
  def initialize(app, repClass)
    super(app)
    @repClass = repClass
  end
  get '/cars' do
    content_type:json

    location = params['location']
    halt 400, {'Content-Type' => 'text/plain'}, 'location parameter missing' unless location

    begin
      coord = GeoCoord.new(location) 
    rescue ArgumentError => error
      halt 400, {'Content-Type' => 'text/plain'}, error.message 
    end

    @repClass.use() do |repository|
      repository.find_cars_by_geocoord(coord)
    end
  end
end
