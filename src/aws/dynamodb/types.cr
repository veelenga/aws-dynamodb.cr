module Aws::DynamoDB::Types
  alias TableDescription = NamedTuple(
    ItemCount: Int64,
    TableArn: String,
    TableName: String,
    TableStatus: String,
    TableSizeBytes: Int64)

  ListTablesOutput  = NamedTuple(TableNames: Array(String), LastEvaluatedTableName: String?)
  CreateTableOutput = NamedTuple(TableDescription: TableDescription)
  DeleteTableOutput = NamedTuple(TableDescription: TableDescription)
end
