Dynamoid.configure do |config|
  config_path = "#{Jets.root}/config/dynamodb.yml"
  parsed = YAML.load(ERB.new(File.read(config_path)).result)[Jets.env]
  namespace, endpoint = parsed['namespace'], parsed['endpoint']

  config.namespace = namespace
  config.endpoint = endpoint

  config.read_capacity = 10 # Read capacity for your tables
  config.write_capacity = 10 # Write capacity for your tables
end
