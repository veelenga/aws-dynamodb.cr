require "../src/aws/dynamodb"

client = Aws::DynamoDB::Client.new(
  region: "eu-central-1",
  aws_access_key: ENV["AWS_ACCESS_KEY"],
  aws_secret_key: ENV["AWS_SECRET_KEY"],
  endpoint: "http://localhost:8000"
)

pp client.create_table(
  TableName: "Thread",
  AttributeDefinitions: [
    {
      AttributeName: "ForumName",
      AttributeType: "S",
    },
    {
      AttributeName: "Subject",
      AttributeType: "S",
    },
    {
      AttributeName: "LastPostDateTime",
      AttributeType: "S",
    },
  ],
  KeySchema: [
    {
      AttributeName: "ForumName",
      KeyType:       "HASH",
    },
    {
      AttributeName: "Subject",
      KeyType:       "RANGE",
    },
  ],
  LocalSecondaryIndexes: [
    {
      IndexName: "LastPostIndex",
      KeySchema: [
        {
          AttributeName: "ForumName",
          KeyType:       "HASH",
        },
        {
          AttributeName: "LastPostDateTime",
          KeyType:       "RANGE",
        },
      ],
      Projection: {
        ProjectionType: "KEYS_ONLY",
      },
    },
  ],
  ProvisionedThroughput: {
    ReadCapacityUnits:  5,
    WriteCapacityUnits: 5,
  },
  Tags: [
    {
      Key:   "Owner",
      Value: "BlueTeam",
    },
  ],
)

pp client.list_tables

pp client.delete_table(TableName: "Thread")
