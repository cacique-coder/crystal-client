require "http/client"
require "json"
require "mutex"
require "oauth2"
require "uri"
require "placeos-models" # is there a better place for this require?

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

    protected getter authenticate : HTTP::Client -> = ->(_client : HTTP::Client) {}
    protected getter uri : URI

    # TODO:
    # before_request
    # connect_timeout=
    # read_timeout=

    def initialize(uri : URI | String, &authenticate : HTTP::Client ->)
      @uri = uri.is_a?(String) ? URI.parse(uri) : uri
      @authenticate = authenticate
    end

    def initialize(uri : URI | String)
      @uri = uri.is_a?(String) ? URI.parse(uri) : uri
    end

    def connection
      HTTP::Client.new(uri) do |client|
        authenticate.call(client)
        yield client
      end
    end
  end
end

require "./api_wrapper/**"
