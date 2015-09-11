require 'sinatra'
require 'geocoord'

get '/cars' do
  location = params['location']
  
  halt 400, {'Content-Type' => 'text/plain'}, 'location parameter missing' unless location

  coord = GeoCoord.new(location) rescue nil
  
  halt 400, {'Content-Type' => 'text/plain'}, 'location parameter malformed' unless coord 
end
