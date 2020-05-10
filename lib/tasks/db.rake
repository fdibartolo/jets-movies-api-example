namespace :movies_api do
  namespace :db do
    desc "Drops all tables and regenerates them"
    task :reset do
      Dynamoid::Config.logger=false
      Rake::Task["movies_api:db:drop"].execute
      puts "=> Creating tables...".yellow
      Dynamoid.included_models.each { |m| m.create_table(sync: true) }
      puts "=> Done!".green
    end

    desc "Seeds tables with files db/sample_*.json"
    task :seed do
      Dynamoid::Config.logger=false
      Rake::Task["movies_api:db:reset"].execute if Dynamoid.adapter.list_tables.empty?
      puts "=> Seeding tables...".yellow
      movies = File.read('db/sample_movies.json')
      Movie.import(JSON.parse(movies))
      puts "=> Done!".green
    end

    desc "Drops all tables"
    task :drop do
      Dynamoid::Config.logger=false
      puts "=> Dropping tables...".yellow
      Dynamoid.adapter.list_tables.each do |table|
        # Only delete tables in our namespace
        if table =~ /^#{Dynamoid::Config.namespace}/
          Dynamoid.adapter.delete_table(table)
        end
      end
      Dynamoid.adapter.tables.clear
      puts "=> Done!".green
    end
  end
end