require "json"

module Aws::DynamoDB::Types
  struct TableDescription
    include JSON::Serializable

    @[JSON::Field(key: "ItemCount")]
    property item_count : Int64

    @[JSON::Field(key: "TableArn")]
    property table_arn : String

    @[JSON::Field(key: "TableName")]
    property table_name : String

    @[JSON::Field(key: "TableStatus")]
    property table_status : String

    @[JSON::Field(key: "TableSizeBytes")]
    property table_size_bytes : Int64
  end
end
