require "uri"
require "http/client"
require "oauth2"
require "json"
require "./api/**"

# Low-level wrapper for the PlaceOS API.
#
# Each method maps one-to-one with an API endpoint. All invocations will either
# provide a type-safe response object, or raise an `PlaceOS::Client::API::Error`.
#
# It's possible to use this class directly if you require the extra flexibility,
# however in most cases the abstractions provided by the higher-level
# `PlaceOS::Client` may be the better choice.
module PlaceOS
  class Client::APIWrapper
    include Client::API::Models

    # Underlying HTTP connection
    protected getter connection : HTTP::Client

    delegate :before_request, :connect_timeout=, :close, :read_timeout=, to: connection

    def initialize(uri : URI | String, token : OAuth2::AccessToken? = nil)
      uri = URI.parse(uri) if uri.is_a?(String)
      @connection = HTTP::Client.new uri

      # Authenticate the client if a token was provided
      token.authenticate(connection) if token
    end

    def authenticate(token : OAuth2::AccessToken)
      token.authenticate(connection)
    end
  end
end

require "./api_wrapper/**"
