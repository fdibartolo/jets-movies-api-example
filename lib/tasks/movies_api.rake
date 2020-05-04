namespace :movies_api do
  desc "Starts app and database instance locally"
  task :start do
    ENV['LOCAL'] = 'true'
    puts "\nStarting local instance of the app with #{"LOCAL".green.bold} instance of dynamodb...\n\n"

    # create tables if needed, silently, on a new process
    Process.fork do
      sleep 5 # HACK, wait for dynamodb to start (below...)
      puts "Syncing dynamodb table...".yellow
      result = `jets runner 'Dynamoid.included_models.each { |m| m.create_table(sync: true) }'`
      puts "Dynamodb table synced!".green if $?.success?
    end    

    # start verbosely via foreman
    system "bin/start"
  end

  desc "Deploys new stack into aws"
  task :aws_deploy do
    puts "Syncing dynamodb table if needed...".yellow
    prefix = `JETS_ENV=staging jets runner 'puts Jets.config.table_namespace'`.split("\n")[-1] # HELL OF A HACK :|
    Dir.chdir("infra") { system "terraform apply -var 'tablename=#{prefix}_movies' -auto-approve" }
    puts "Dynamodb table synced!".green

    puts "Provisioning lambdas, endpoints if needed...".yellow
    system "JETS_ENV=staging jets deploy"
    puts "Done!".green
  end

  desc "Destroys aws stack"
  task :aws_destroy do
    # TODO: ask for confirmation once, and force both ops below
    puts "Destroying dynamodb table...".yellow
    Dir.chdir("infra") { system "terraform destroy -var 'tablename=x'" }
    puts "Done destroying table!".green

    puts "Destroying lambdas, endpoints...".yellow
    system "JETS_ENV=staging jets delete"
    puts "Done!".green
  end
end
