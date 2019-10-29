require "uri"
require "http/client"
require "oauth2"
require "json"
require "./api/error"
require "./api_wrapper/*"

# Low-level wrapper for the ACAEngine API.
#
# Each method maps one-to-one with an API endpoint and returns the response that the API returns
# with or raises an `ACAEngine::API::Error`. It's possible to use this class directly if you
# require the extra flexibility, however in most cases the abstractions provided by the
# higher-level `ACAEngine::Client` may be the better choice.
class ACAEngine::APIWrapper
  include API::Models

  # Underlying HTTP connection
  private getter connection : HTTP::Client

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

  # Build a `HTTP::Params` instance from local context.
  #
  # Accepts a set of potentially nilable references and expands into params
  # instance containing any of these entities with a non-nil value.
  macro params_from(*keys)
    HTTP::Params.build do |param|
      {% for key in keys %}
        param.add {{key.id.stringify}}, {{key.id}}.to_s unless {{key.id}}.nil?
      {% end %}
    end
  end

  # Builds a `HTTP::Params` instance from local method arguments.
  #
  # Maps any method arguments that contain a value other than their default
  # into params on the expanded object.
  #
  # The optional *except* parameter may be used to filter to a subset of
  # arguments only.
  macro params_from_args(except = [id])
    {% except = [except] unless except.is_a? ArrayLiteral %}
    {% except = except.map &.id %}
    {% args = @def.args.reject { |arg| except.includes? arg.name } %}

    HTTP::Params.build do |param|
      {% for arg in args %}
        # Always include required args, the compiler doesn't like Nop's
        {% if arg.default_value.is_a? Nop %}
          param.add {{arg.name.stringify}}, {{arg.name}}.to_s
        {% else %}
          param.add {{arg.name.stringify}}, {{arg.name}}.to_s \
            unless {{arg.name}} == {{arg.default_value}}
        {% end %}
      {% end %}
    end
  end

  # Builds a JSON string from local context.
  #
  # Accepts a set of potentially nilable references and builds a `String`
  # containing JSON representation of all with non-nil values.
  macro json_from(*keys)
    JSON.build do |json|
      json.object do
        {% for key in keys %}
          json.field {{key.id.stringify}}, {{key.id}} unless {{key.id}}.nil?
        {% end %}
      end
    end
  end

  # Builds a JSON string from local method arguments.
  #
  # Maps any method arguments that contain a value other than their default
  # into params on the expanded object.
  #
  # The optional *except* parameter may be used to filter to a subset of
  # arguments only.
  macro json_from_args(except = [id])
    {% except = [except] unless except.is_a? ArrayLiteral %}
    {% except = except.map &.id %}
    {% args = @def.args.reject { |arg| except.includes? arg.name } %}
    JSON.build do |json|
      json.object do
        {% for arg in args %}
          # Always include required args
          {% if arg.default_value.is_a? Nop %}
            json.field {{arg.name.stringify}}, {{arg.name}}
          {% else %}
            json.field {{arg.name.stringify}}, {{arg.name}} \
              unless {{arg.name}} == {{arg.default_value}}
          {% end %}
        {% end %}
      end
    end
  end

  {% for method in %w(get post put head delete patch options) %}
    # Executes a {{method.id.upcase}} request on the client connection.
    #
    # The response status will be automatically checked and a
    # `ACAEngine::Client::Error` raised if unsuccessful.
    protected def {{method.id}}(path, headers : HTTP::Headers? = nil, body : HTTP::Client::BodyType? = nil)
      headers ||= HTTP::Headers.new
      headers["Content-Type"] = "application/json" unless body.nil?
      response = connection.{{method.id}} path, headers, body
      raise API::Error.from_response(response) unless response.success?
      response
    end
  {% end %}
end
