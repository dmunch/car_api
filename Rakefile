require 'rspec/core/rake_task'

task :default do
  conf = File.expand_path('config.ru', File.dirname(__FILE__))
  `thin -R #{conf} start -p 5000`
end

namespace :db do
  task :init do
  `
    HOST=${POSTGIS_PORT_5432_TCP_ADDR:-192.168.99.100}
    PORT=${POSTGIS_PORT_5432_TCP_PORT:-5432}
    PGUSER=${PGUSER:-postgres}

    #when we run inside a docker container it sometimes takes a while until postgres is accepting connections
    #hence this loop
    until psql -h $HOST -U $PGUSER -p $PORT -f db/init.sql
    do
       sleep 10 
    done`
  end
  task :seed do
    ruby "db/seed.rb"
  end
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "-f d --tag ~benchmark" 
end
namespace :spec do
  RSpec::Core::RakeTask.new(:benchmark) do |t|
    t.rspec_opts = "-f d --tag benchmark" 
  end
end
