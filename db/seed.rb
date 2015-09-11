$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__) 
require 'car_repository'
require 'json'

file = File::read('data.json')
car_data = JSON.parse(file)

rep = CarRepository.new()
rep.delete_all()

car_data['locations'].cycle(1).each do |location|
  rep.insert(location)
end
