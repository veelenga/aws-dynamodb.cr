require "./aws-dynamodb/client"

module Aws::DynamoDB
  VERSION = "0.1.0"

  METADATA = {
    service_name:  "dynamodb",
    service_id:    "DynamoDB",
    target_prefix: "DynamoDB_20120810",
  }
end
