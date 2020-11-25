require "json"
require "./table_description"

module Aws::DynamoDB::Types
  struct DeleteTableOutput
    include JSON::Serializable

    @[JSON::Field(key: "TableDescription")]
    property table_description : TableDescription
  end
end
