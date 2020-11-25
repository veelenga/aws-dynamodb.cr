require "json"

module Aws::DynamoDB::Types
  struct ListTablesOutput
    include JSON::Serializable

    @[JSON::Field(key: "TableNames")]
    property table_names : Array(String)

    @[JSON::Field(key: "LastEvaluatedTableName")]
    property last_evaluated_table_name : String?
  end
end
