require "spec"
require "webmock"
require "../src/aws-dynamodb"

DEFAULT_ENDPOINT = "http://localhost:8000"

def new_client(version = :v4, endpoint = DEFAULT_ENDPOINT)
  Aws::DynamoDB::Client.new(
    region: "region",
    aws_access_key_id: "aws_access_key_id",
    aws_secret_access_key: "aws_secret_access_key",
    endpoint: endpoint,
    version: version
  )
end

def stub_client(request, response, op : String, endpoint = DEFAULT_ENDPOINT)
  WebMock.stub(:post, endpoint).with(
    body: request.to_json,
    headers: HTTP::Headers{
      "X-Amz-Target" => "#{Aws::DynamoDB::METADATA[:target_prefix]}.#{op}",
      "Content-Type" => "application/x-amz-json-1.0",
    }
  ).to_return(status: 200, body: response.to_json)
end

def stub_client_error(message = "Invalid params", status = 400, endpoint = DEFAULT_ENDPOINT)
  WebMock.stub(:post, endpoint).to_return(
    status: status,
    body: {message: message}.to_json
  )
end
