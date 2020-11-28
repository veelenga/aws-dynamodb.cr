require "../spec_helper"

module Aws::DynamoDB
  describe Client do
    Spec.before_each &->WebMock.reset

    describe "#initialize" do
      it "creates signed http client" do
        new_client.http.should_not be_nil
      end

      it "raises if version is not valid" do
        expect_raises(ArgumentError, "Unknown signer version: v1") do
          new_client(version: :v1)
        end
      end
    end # initialize

    describe "#list_tables" do
      it "sends a valid request and returns response" do
        request = {} of String => String
        response = {
          TableNames:             ["Table1", "Table2"],
          LastEvaluatedTableName: "Table3",
        }

        stub_client(request, response, op: "ListTables")
        new_client.list_tables.should eq(response)
      end

      it "raises in case of error" do
        stub_client_error

        expect_raises(Http::ServerError, "Invalid params") do
          new_client.list_tables
        end
      end
    end # list_tables

    describe "#create_table" do
      it "sends a valid request and returns response" do
        request = {
          TableName:            "Table1",
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
        }

        response = {
          TableDescription: {
            ItemCount:      3,
            TableArn:       "arn",
            TableName:      "Table1",
            TableStatus:    "ACTIVE",
            TableSizeBytes: 338_943_234,
          },
        }

        stub_client(request, response, op: "CreateTable")
        new_client.create_table(**request).should eq(response)
      end

      it "raises in case of error" do
        stub_client_error
        expect_raises(Http::ServerError, "Invalid params") do
          new_client.create_table(TableName: "Doe")
        end
      end
    end # create_table

    describe "#delete_table" do
      it "sends a valid request and returns response" do
        request = {
          TableName: "Table1",
        }

        response = {
          TableDescription: {
            ItemCount:      3,
            TableArn:       "arn",
            TableName:      "Table1",
            TableStatus:    "ACTIVE",
            TableSizeBytes: 338_943_234,
          },
        }

        stub_client(request, response, "DeleteTable")
        new_client.delete_table(**request).should eq(response)
      end

      it "raises in case of error" do
        stub_client_error
        expect_raises(Http::ServerError, "Invalid params") do
          new_client.delete_table(TableName: "Doe")
        end
      end
    end # delete_table

    describe "#put_item" do
      it "sends a valid request and returns response" do
        request = {
          TableName: "Table1",
          Item: {
            AttributeName: "value"
          }
        }

        response = {
          Attributes: {
            AttributeName: {
              Value: "value"
            }
          }
        }

        stub_client(request, response, "PutItem")
        resp = new_client.put_item(**request)
        resp["Attributes"].should_not be_nil
      end

      it "raises in case of error" do
        stub_client_error
        expect_raises(Http::ServerError, "Invalid params") do
          new_client.put_item(TableName: "Doe")
        end
      end
    end # put_item

    describe "#get_item" do
      it "sends a valid request and returns response" do
        request = {
          TableName: "Table1",
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
        }

        response = {
          ConsumedCapacity: {
            CapacityUnits: 1,
            TableName: "Thread",
            ReadCapacityUnits: nil,
            WriteCapacityUnits: nil
          },
          Item: {
            Tags: {
              SS: ["Update","Multiple Items","HelpMe"]
            },
            Message: {
              S: "Message"
            }
          }
        }

        stub_client(request, response, "GetItem")
        resp = new_client.get_item(**request)
        resp["ConsumedCapacity"].should eq response["ConsumedCapacity"]
        resp["Item"].try &.["Tags"]["SS"].should eq response["Item"]["Tags"]["SS"]
        resp["Item"].try &.["Message"]["S"].should eq response["Item"]["Message"]["S"]
      end

      it "raises in case of error" do
        stub_client_error
        expect_raises(Http::ServerError, "Invalid params") do
          new_client.get_item(TableName: "Doe")
        end
      end
    end # get_item
  end   # Client
end
