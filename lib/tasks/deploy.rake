namespace :movies_api do
  desc "Meant to be run within CI server, in order to init tool stack"
  task :deploy_init do
    Dir.chdir("infra") { system "terraform init -input=false" }
    Dir.chdir("infra") { system "terraform plan -var 'tablename=dummy' -input=false" }
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
    confirm = forced? ? 'yes' : (
      puts "Are you sure you want to want to delete the project? **There is no undo**. Only 'yes' will be accepted to confirm:".cyan
      print " -> ".cyan
      confirm = STDIN.gets
    )

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

  def forced?
    ENV['FORCE_DESTROY']=='true'
  end
end
