
task :initdb do
  `psql -h 192.168.99.100 -U postgres -p 5432 -f db/init.sql`
end
task :seeddb do
    ruby "db/seed.rb"
end
