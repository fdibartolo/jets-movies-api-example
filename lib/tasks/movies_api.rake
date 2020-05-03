namespace :movies_api do
  desc "Starts app and database instance locally"
  task :start do
    ENV['LOCAL'] = 'true'
    puts "\nStarting local instance of the app with #{"LOCAL".green.bold} instance of dynamodb...\n\n"

    # create tables if needed, silently, on a new process
    pid = Process.fork do
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
    ENV['LOCAL'] = nil

    puts "Provisioning dynamodb table if needed...".yellow
    Dir.chdir("infra") { system "terraform apply" }
    puts "Done provisioning table!".green

    puts "Provisioning lambdas and endpoints if needed...".yellow
    system "jets deploy"
    puts "Done!".green

    # result = `heroku --version`
    # if $?.success?
    #   puts "- #{result[0..-3]} is present".green
    # else
    #   raise "Heroku toolbelt is not installed. If you are on OSX, consider installing it via homebrew. Refer to this for more info: https://github.com/heroku/toolbelt/issues/53#issuecomment-47022750".red
    # end
  end

  desc "Destroys aws stack"
  task :aws_destroy do
    puts "Destroying dynamodb table...".yellow
    Dir.chdir("infra") { system "terraform destroy" }
    puts "Done destroying table!".green

    puts "Destroying lambdas and endpoints...".yellow
    system "jets delete"
    puts "Done!".green
  end
end
