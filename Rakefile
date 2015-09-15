require 'rspec/core/rake_task'

task :initdb do
  `psql -h 192.168.99.100 -U postgres -p 5432 -f db/init.sql`
end
task :seeddb do
    ruby "db/seed.rb"
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "-f d --tag ~benchmark" 
end
namespace :spec do
RSpec::Core::RakeTask.new(:benchmark) do |t|
  t.rspec_opts = "-f d --tag benchmark" 
end
end
