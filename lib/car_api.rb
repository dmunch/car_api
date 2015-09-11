require 'sinatra'
require 'geocoord'

get '/cars' do
  location = params['location']
  halt 400, {'Content-Type' => 'text/plain'}, 'location parameter missing' unless location

  begin
    coord = GeoCoord.new(location) 
  rescue ArgumentError => error
    halt 400, {'Content-Type' => 'text/plain'}, error.message 
  end
end
