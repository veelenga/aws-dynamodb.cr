# aws-dynamodb

Crystal client for AWS DynamoDB.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     aws-dynamodb:
       github: veelenga/aws-dynamodb.cr
   ```

2. Run `shards install`

## Usage

### Initialize client

```crystal
require "aws/dynamodb"

client = Aws::DynamoDB::Client.new(
  region: ENV["AWS_REGION"],
  aws_access_key: ENV["AWS_ACCESS_KEY"],
  aws_secret_key: ENV["AWS_SECRET_KEY"],
  endpoint: ENV["DYNAMODB_URL"]
)

```

### Create table

``` crystal
client.create_table(
  TableName: "Movies",
  AttributeDefinitions: [
    {
      AttributeName: "Year",
      AttributeType: "N"
    },
    {
      AttributeName: "Name",
      AttributeType: "S"
    }
  ],
  KeySchema: [
    {
      AttributeName: "Name",
      KeyType:       "HASH"
    },
    {
      AttributeName: "Year",
      KeyType:       "RANGE"
    }
  ],
  ProvisionedThroughput: {
    ReadCapacityUnits:  5,
    WriteCapacityUnits: 5
  }
)

```

### Put Item

``` crystal
client.put_item(
  TableName: "Movies",
  Item: {
    Year: { N: 2008 },
    Name: { S: "The Dark Knight" }
  }
)

```

### Get Item

```crystal
response = client.get_item(
  TableName: "Movies",
  Key: {
    Year: { N: 2008 },
    Name: { S: "The Dark Knight" }
  }
)
response["Item"].try &.["Name"].s #=> "The Dark Knight"
```

## Development

1. [Setting Up DynamoDB Local](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html).
Alternatively it can be running in a container:

``` sh
$ docker pull amazon/dynamodb-local
$ docker run -p 8000:8000 amazon/dynamodb-local
```

2. Pass credentials + DB URL and run the examples:

```sh
$ AWS_REGION=..\
  AWS_ACCESS_KEY=...\
  AWS_SECRET_KEY=...\
  DYNAMODB_URL=http://localhost:8000\
  crystal examples/put_get_item.cr
```

## Contributors

- [veelenga](https://github.com/veelenga) - creator and maintainer
