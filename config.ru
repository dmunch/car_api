require 'rubygems'
require 'bundler'
$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"
Bundler.require
require 'car_api'
require 'car_repository'

app = CarApi.new(nil, CarRepository.new())
run app
#run CarApi.new(app, repository: CarRepository.new()) 
