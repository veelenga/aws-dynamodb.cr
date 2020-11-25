require "../utils/http"
require "./types/*"
require "awscr-signer"

module Aws::DynamoDB
  class Client
    getter http : Utils::Http

    def initialize(
      @region : String,
      @aws_access_key : String,
      @aws_secret_key : String,
      @endpoint : String? = nil,
      version : Symbol = :v4
    )
      signer = initialize_signer(version)
      @http = initialize_http(signer)
    end

    def list_tables
      response = http.post("/", body: "{}", op: "ListTables")
      Types::ListTablesOutput.from_json(response.body)
    end

    def create_table(params)
      response = http.post("/", body: params, op: "CreateTable")
      Types::CreateTableOutput.from_json(response.body)
    end

    def delete_table(params)
      response = http.post("/", body: params, op: "DeleteTable")
      Types::DeleteTableOutput.from_json(response.body)
    end

    private def initialize_signer(version)
      case version
      when :v4
        Awscr::Signer::Signers::V4.new(
          service: METADATA[:service_name],
          region: @region,
          aws_access_key: @aws_access_key,
          aws_secret_key: @aws_secret_key
        )
      when :v2
        Awscr::Signer::Signers::V2.new(
          service: METADATA[:service_name],
          region: @region,
          aws_access_key: @aws_access_key,
          aws_secret_key: @aws_secret_key
        )
      else
        raise "Unknown signer version: #{version}"
      end
    end

    private def initialize_http(signer)
      Utils::Http.new(
        signer: signer,
        region: @region,
        custom_endpoint: @endpoint,
        service_name: METADATA[:service_name]
      )
    end
  end
end
