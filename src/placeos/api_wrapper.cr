require "uri"
require "http/client"
require "oauth2"
require "json"
require "./api/**"
require "./api_wrapper/**"

# Low-level wrapper for the PlaceOS API.
#
# Each method maps one-to-one with an API endpoint. All invocations will either
# provide a type-safe response object, or raise an `PlaceOS::API::Error`.
#
# It's possible to use this class directly if you require the extra flexibility,
# however in most cases the abstractions provided by the higher-level
# `PlaceOS::Client` may be the better choice.
class PlaceOS::APIWrapper
  include API::Models

  # Underlying HTTP connection
  private getter connection : HTTP::Client

  delegate :before_request, :connect_timeout=, :read_timeout=, to: connection

  def initialize(base_url)
    uri = URI.parse base_url
    @connection = HTTP::Client.new uri
  end

  # Sets the authentication used by the API client.
  #
  # All client instances must be authenticated prior to interaction with
  # protected endpoints.
  def auth=(token_provider : OAuth2::AccessToken | OAuth2::Session)
    token_provider.authenticate connection
  end

  # Yields a stringified key, reference and default value for arguments of
  # interest from the enclosing method.
  #
  # Handles a few common mappings / exlusions.
  private macro each_arg(&block)
    # Ignore `id` as this it used exlusively in path params.
    {% for arg in @def.args.reject(&.name.symbolize.== :id) %}
      # `module` is a reserved word, remap mod -> module
      {% key = arg.name.symbolize == :mod ? "module" : arg.name.stringify %}
      {{ yield key, arg.name, arg.default_value }}
    {% end %}
  end

  {% for method in %w(get post put head delete patch options) %}
    # Executes a {{method.id.upcase}} request on the client connection.
    #
    # The response status will be automatically checked and a
    # `PlaceOS::Client::Error` raised if unsuccessful.
    #
    # Macro expansion allows this to obtain context from a surround method and
    # use method arguments to build an appropriate request structure. Pass
    # `from_args` to to either *params* or *body* for the magic to happen.
    # Alternatively, you may specify a NamedTuple for the contents of either of
    # these.
    #
    # Us *as* to specify a JSON parse-able model that the response should be
    # piped into. If unspecified a `JSON::Any` will be returned.
    macro {{method.id}}(path, params = nil, headers = nil, body = nil, as model = nil)
      {% verbatim do %}
        # Append query params to the path
        {% if params.id.symbolize == :from_args %}
          params = HTTP::Params.build do |param|
            each_arg do |key, val, default|
              param.add \{{key}}, \{{val}}.to_s unless \{{val}} == \{{default}}
            end
          end
          path = "#{{{path}}}?#{params}"
        {% else %}
          path = "#{{{path}}}?#{{{params}}}"
        {% end %}

        headers = {{headers}}

        # Build a body (if required)
        {% if body.id.symbolize == :from_args || body.is_a? NamedTupleLiteral %}
          headers ||= HTTP::Headers.new
          headers["Content-Type"] = "application/json"
          body = JSON.build do |json|
            json.object do
              {% if body.id.symbolize == :from_args %}
                each_arg do |key, val, default|
                  json.field \{{key}}, \{{val}} unless \{{val}} == \{{default}}
                end
              {% elsif body.is_a? NamedTupleLiteral %}
                {% for key, value in body %}
                  json.field {{key.stringify}}, {{value}}
                {% end %}
              {% end %}
            end
          end
        {% else %}
          body = {{body}}
        {% end %}
      {% end %}

      # Exec the request
      response = connection.{{method.id}} path, headers, body
      raise API::Error.from_response(response) unless response.success?

      # Parse the response
      {% verbatim do %}
        {% if model %}
          {{model}}.from_json response.body
        {% else %}
          if response.body.empty?
            JSON::Any.new nil
          else
            JSON.parse response.body
          end
        {% end %}
      {% end %}
    end
  {% end %}
end
