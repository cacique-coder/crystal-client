require "uri"
require "http/client"
require "oauth2"
require "json"
require "./error"
require "./api/*"

# Low-level wrapper for the ACAEngine API.
#
# Each method maps one-to-one with an API endpoint and returns the response that the API returns
# with or raises an `ACAEngine::Client::Error`. It's possible to use this class directly if you
# require the extra flexibility, however in most cases the abstractions provided by the
# higher-level `ACAEngine::Client` may be the better choice.
class ACAEngine::Client::Api
  # :no_doc:
  # Underlying HTTP connection - exposed for access from test framework only.
  getter connection : HTTP::Client

  def initialize(base_url)
    uri = URI.parse base_url
    @connection = HTTP::Client.new uri
  end

  # Sets the authentication used by the API client.
  #
  # All client instances must be authenticated prior to interaction with protected endpoints.
  def auth=(token : OAuth2::AccessToken | OAuth2::Session)
    token_provider.authenticate connection
  end

  {% for method in %w(get post put head delete patch options) %}
    # Executes a {{method.id.upcase}} request on the client connection.
    #
    # The response status will be automatically checked and a ACAEngine::Client::Error raised if
    # unsuccessful.
    def {{method.id}}(path, headers : HTTP::Headers? = nil, body : HTTP::Client::BodyType? = nil)
      response = connection.{{method.id}} path, headers, body
      raise Error.from_response(response) unless response.success?
      response
    end

    # Executes a {{method.id.upcase}} request on the client connection with a JSON body formed from
    # the passed serializable object.
    def {{method.id}}(path, body)
      headers = HTTP::Headers.new
      headers["Content-Type"] = "application/json"
      {{method.id}} path, headers, body.to_json
    end

    # :ditto:
    def {{method.id}}(path, headers : HTTP::Headers, body : NamedTuple)
      headers["Content-Type"] = "application/json"
      {{method.id}} path, headers, body.camelcase_keys.to_json
    end
  {% end %}
end
