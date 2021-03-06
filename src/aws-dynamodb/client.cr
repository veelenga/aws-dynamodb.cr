require "./http"
require "./types"
require "awscr-signer"
require "json"

module Aws::DynamoDB
  class Client
    getter http : Http

    def initialize(
      @region : String = ENV["AWS_REGION"],
      @aws_access_key_id : String = ENV["AWS_ACCESS_KEY_ID"],
      @aws_secret_access_key : String = ENV["AWS_SECRET_ACCESS_KEY"],
      @aws_session_token : String? = ENV["AWS_SESSION_TOKEN"]?,
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

    def create_table(**params)
      response = http.post("/", body: params.to_json, op: "CreateTable")
      Types::CreateTableOutput.from_json(response.body)
    end

    def delete_table(**params)
      response = http.post("/", body: params.to_json, op: "DeleteTable")
      Types::DeleteTableOutput.from_json(response.body)
    end

    def put_item(**params)
      response = http.post("/", body: params.to_json, op: "PutItem")
      Types::PutItemOutput.from_json(response.body)
    end

    def get_item(**params)
      response = http.post("/", body: params.to_json, op: "GetItem")
      Types::GetItemOutput.from_json(response.body)
    end

    private def initialize_signer(version)
      case version
      when :v4
        Awscr::Signer::Signers::V4.new(
          service: METADATA[:service_name],
          region: @region,
          aws_access_key: @aws_access_key_id,
          aws_secret_key: @aws_secret_access_key,
          amz_security_token: @aws_session_token
        )
      when :v2
        Awscr::Signer::Signers::V2.new(
          service: METADATA[:service_name],
          region: @region,
          aws_access_key: @aws_access_key_id,
          aws_secret_key: @aws_secret_access_key
        )
      else
        raise ArgumentError.new("Unknown signer version: #{version}")
      end
    end

    private def initialize_http(signer)
      Http.new(
        signer: signer,
        region: @region,
        custom_endpoint: @endpoint,
        service_name: METADATA[:service_name]
      )
    end
  end
end
