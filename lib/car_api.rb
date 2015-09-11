require 'sinatra'

get '/cars' do
  location = params['location']
  
  halt 400, {'Content-Type' => 'text/plain'}, 'location parameter missing' unless location
end
