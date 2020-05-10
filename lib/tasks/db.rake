namespace :movies_api do
  namespace :db do
    desc "Checks if dynamodb is running"
    task :dynamo_up do
      pids = IO.popen("ps aux | grep -E 'DynamoDBLocal.jar' | grep -v grep | awk '{print $2}'").readlines.to_a
      raise "=> No dynamodb instance seem to be running.".red if pids.empty?
    end

    desc "Drops all tables and regenerates them"
    task :reset => [:drop] do
      puts "=> Creating tables...".yellow
      Dynamoid.included_models.each { |m| m.create_table(sync: true) }
      puts "=> Done!".green
    end

    desc "Seeds tables with files db/sample_*.json"
    task :seed => [:dynamo_up] do
      Dynamoid::Config.logger=false
      Rake::Task["movies_api:db:reset"].execute if Dynamoid.adapter.list_tables.empty?
      puts "=> Seeding tables...".yellow
      movies = File.read('db/sample_movies.json')
      Movie.import(JSON.parse(movies))
      puts "=> Done!".green
    end

    desc "Drops all tables"
    task :drop => [:dynamo_up] do
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