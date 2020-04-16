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

    delegate :before_request, :connect_timeout=, :read_timeout=, to: connection

    def initialize(uri : URI | String)
      uri = URI.parse(uri) if uri.is_a?(String)
      @connection = HTTP::Client.new uri
    end

    # Sets the authentication used by the API client.
    #
    # All client instances must be authenticated prior to interaction with
    # protected endpoints.
    def auth=(token_provider : OAuth2::AccessToken | OAuth2::Session)
      token_provider.authenticate connection
    end
  end
end

require "./api_wrapper/**"
