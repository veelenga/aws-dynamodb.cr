require "uri"

module Aws::Utils
  class Http
    class ServerError < Exception
    end

    def initialize(
      @signer : Awscr::Signer::Signers::Interface,
      @service_name : String,
      @region : String,
      @custom_endpoint : String? = nil
    )
      @http = HTTP::Client.new(endpoint)
      @http.before_request { |request| @signer.sign(request) }
    end

    def post(path, body : String, op : String)
      headers = HTTP::Headers{
        "X-Amz-Target" => "#{DynamoDB::METADATA[:target_prefix]}.#{op}",
        "Content-Type" => "application/x-amz-json-1.0",
      }
      resp = @http.post(path, headers: headers, body: body)
      handle_response!(resp)
    end

    # :nodoc:
    private def handle_response!(response)
      return response if (200..299).includes?(response.status_code)
      raise ServerError.new("server error (#{response.status_code}): #{response.body}")
    end

    # :nodoc:
    private def endpoint : URI
      return URI.parse(@custom_endpoint.to_s) if @custom_endpoint
      URI.parse("http://#{@service_name}.#{@region}.amazonaws.com")
    end

    # :nodoc:
    private def default_endpoint : URI
      URI.parse("http://#{@service_name}.amazonaws.com")
    end
  end
end
