namespace :movies_api do
  desc "Cleans up the tmp directory built upon deploying"
  task :cleanup do
    path = File.basename Dir.pwd
    Dir.chdir("/tmp/jets") { system "rm -rf #{path}" }
    if $?.success?
      puts "Done!".green.bold
    else
      puts "Unable to clean up '/tmp/jets/#{path}' :(".red
    end
  end
end  