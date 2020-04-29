Dynamoid.configure do |config|
  # To namespace tables created by Dynamoid from other tables you might have.
  # Set to nil to avoid namespacing.
  config.namespace = 'movies_api'

  # [Optional]. If provided, it communicates with the DB listening at the endpoint.
  # This is useful for testing with [DynamoDB Local] (http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.DynamoDBLocal.html).
  config.endpoint = 'http://localhost:8000'

  config.read_capacity = 10 # Read capacity for your tables
  config.write_capacity = 10 # Write capacity for your tables
end

Dynamoid.included_models.each { |m| m.create_table(sync: true) }