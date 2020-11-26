require "../src/aws/dynamodb"

client = Aws::DynamoDB::Client.new(
  region: ENV["AWS_REGION"],
  aws_access_key: ENV["AWS_ACCESS_KEY"],
  aws_secret_key: ENV["AWS_SECRET_KEY"],
  endpoint: ENV["DYNAMODB_URL"]? || "http://localhost:8000"
)

table_name = "Thread"

if client.list_tables["TableNames"].includes?(table_name)
  client.delete_table(TableName: table_name)
end

puts "----> Create table"
client.create_table(
  TableName: table_name,
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

puts "----> Put Item"
client.put_item(
  TableName: table_name,
  Item: {
    LastPostDateTime: {
      S: "201303190422",
    },
    Tags: {
      SS: ["Update", "Multiple Items", "HelpMe"],
    },
    ForumName: {
      S: "Amazon DynamoDB",
    },
    Message: {
      S: "I want to update multiple items in a single call. What's the best way to do that?",
    },
    Subject: {
      S: "How do I update multiple items?",
    },
    LastPostedBy: {
      S: "fred@example.com",
    },
  },
  ConditionExpression: "ForumName <> :f and Subject <> :s",
  ExpressionAttributeValues: {
    ":f": {S: "Amazon DynamoDB"},
    ":s": {S: "How do I update multiple items?"},
  }
)

puts "----> Get Item"
response = client.get_item(
  TableName: table_name,
  Key: {
    ForumName: {
      "S": "Amazon DynamoDB"
    },
    Subject: {
      "S": "How do I update multiple items?"
    }
  },
  ProjectionExpression:"LastPostDateTime, Message, Tags",
  ConsistentRead: true,
  ReturnConsumedCapacity: "TOTAL"
)

pp response
pp response["Item"]["Message"].s
pp response["Item"]["LastPostDateTime"].s
pp response["Item"]["Tags"].ss
