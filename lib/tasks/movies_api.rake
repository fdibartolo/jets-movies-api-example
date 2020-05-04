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
    puts "Starting deployment...".yellow

    db_pid = Process.fork do
      puts "=> Syncing dynamodb table...".yellow
      prefix = `JETS_ENV=staging jets runner 'puts Jets.config.table_namespace'`.split("\n")[-1] # HELL OF A HACK :|
      Dir.chdir("infra") { system "terraform apply -var 'tablename=#{prefix}_movies' -auto-approve" }
      puts "=> Dynamodb table synced!".green if $?.success?
      exit $?.exitstatus
    end

    api_pid = Process.fork do
      puts "=> Syncing lambdas, endpoints...".yellow
      system "JETS_ENV=staging jets deploy"
      puts "=> API stack ready!".green if $?.success?
      exit $?.exitstatus
    end

    result = Process.waitall
    if result.map {|d| d[1]}.inject(true) {|m,e| m & (e == 0) } # if all exit with 0
      puts "Deployment successful!, look for the url above =D".green.bold
    else
      puts "Something went wrong, check the logs above :(".red
    end
  end

  desc "Destroys aws stack"
  task :aws_destroy do
    puts "Are you sure you want to want to delete the project? **There is no undo**. Only 'yes' will be accepted to confirm:".cyan
    print " -> ".cyan
    confirm = STDIN.gets

    if confirm.chomp == 'yes'
      db_pid = Process.fork do
        puts "=> Destroying dynamodb table...".yellow
        Dir.chdir("infra") { system "terraform destroy -var 'tablename=x' -auto-approve" }
        puts "=> Done destroying table!".green if $?.success?
        exit $?.exitstatus
      end

      api_pid = Process.fork do
        puts "=> Destroying lambdas, endpoints...".yellow
        system "JETS_ENV=staging jets delete --sure"
        puts "=> Done destroying api stack!".green if $?.success?
        exit $?.exitstatus
      end

      result = Process.waitall
      if result.map {|d| d[1]}.inject(true) {|m,e| m & (e == 0) } # if all exit with 0
        puts "Project stack successfully deleted.".green.bold
      else
        puts "Something went wrong, check the logs above :(".red
      end
    else
      puts "Destroy project stack aborted!".red
    end
  end
end
