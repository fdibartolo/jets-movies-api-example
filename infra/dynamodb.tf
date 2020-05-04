provider "aws" {
  region = "sa-east-1"
}

variable "tablename" {
  type = string
}

resource "aws_dynamodb_table" "movies-table" {
  name           = var.tablename
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
