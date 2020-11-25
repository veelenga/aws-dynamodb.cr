require "../utils/http"
require "./types/*"
require "awscr-signer"

module Aws::DynamoDB
  class Client
    SERVICE_NAME = "dynamodb"
    @signer : Awscr::Signer::Signers::Interface

    def initialize(@region : String, @aws_access_key : String, @aws_secret_key : String, @endpoint : String? = nil, version : Symbol = :v4)
      @signer = initialize_signer(version)
    end

    def list_tables
      response = http.post("/", body: "{}", headers: {"X-Amz-Target" => "DynamoDB_20120810.ListTables"})
      Types::ListTablesOutput.from_json(response.body)
    end

    def create_table(params)
      response = http.post("/", body: params, headers: {"X-Amz-Target" => "DynamoDB_20120810.CreateTable"})
      Types::CreateTableOutput.from_json(response.body)
    end

    def delete_table(params)
      response = http.post("/", body: params, headers: {"X-Amz-Target" => "DynamoDB_20120810.DeleteTable"})
      Types::DeleteTableOutput.from_json(response.body)
    end

    private def initialize_signer(version)
      case version
      when :v4
        Awscr::Signer::Signers::V4.new(
          service: SERVICE_NAME,
          region: @region,
          aws_access_key: @aws_access_key,
          aws_secret_key: @aws_secret_key
        )
      when :v2
        Awscr::Signer::Signers::V2.new(
          service: SERVICE_NAME,
          region: @region,
          aws_access_key: @aws_access_key,
          aws_secret_key: @aws_secret_key
        )
      else
        raise "Unknown signer version: #{version}"
      end
    end

    private def http
      Utils::Http.new(signer: @signer, region: @region, custom_endpoint: @endpoint, service_name: SERVICE_NAME)
    end
  end
end
