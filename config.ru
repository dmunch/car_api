require 'rubygems'
require 'bundler'
$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"
Bundler.require
require 'car_api'
require 'car_repository'

app = CarApi.new(nil, CarRepository)
run app
