provider "aws" {
  region = "sa-east-1"
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "movies_api_movies"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "id"
  range_key      = "title"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "title"
    type = "S"
  }
}
