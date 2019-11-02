require "uri"
require "http/client"
require "oauth2"
require "json"
require "./api/error"
require "./api/models/*"
require "./api_wrapper/*"

# Low-level wrapper for the ACAEngine API.
#
# Each method maps one-to-one with an API endpoint. All invocations will either
# provide a type-safe response object, or raise an `ACAEngine::API::Error`.
#
# It's possible to use this class directly if you require the extra flexibility,
# however in most cases the abstractions provided by the higher-level
# `ACAEngine::Client` may be the better choice.
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
  # All client instances must be authenticated prior to interaction with
  # protected endpoints.
  def auth=(token : OAuth2::AccessToken | OAuth2::Session)
    token_provider.authenticate connection
  end

  {% for method in %w(get post put head delete patch options) %}
    # Executes a {{method.id.upcase}} request on the client connection.
    #
    # The response status will be automatically checked and a
    # `ACAEngine::Client::Error` raised if unsuccessful.
    #
    # Macro expansion allows this to obtain context from a surround method and
    # use method arguments to build an appropriate request structure. Pass
    # `from_args` to to either *params* or *body* for the magic to happen.
    #
    # Us *as* to specify a JSON parse-able model that the response should be
    # piped into. If unspecified a `JSON::Any` will be returned.
    macro {{method.id}}(path, params = nil, headers = nil, body = nil, as model = nil)
      {% verbatim do %}
        # Append query params to the path
        {% if params == nil %}
          path = {{path}}
        {% elsif params.id == :from_args.id %}
          params = HTTP::Params.build do |param|
            {% for arg in @def.args.reject { |arg| arg.name == :id.id } %}
              # Always include required args, the compiler doesn't like Nop's
              {% if arg.default_value.is_a? Nop %}
                param.add {{arg.name.stringify}}, {{arg.name}}.to_s
              {% else %}
                param.add {{arg.name.stringify}}, {{arg.name}}.to_s \
                  unless {{arg.name}} == {{arg.default_value}}
              {% end %}
            {% end %}
          end
          path = "#{{{path}}}?#{params}"
        {% else %}
          path = "#{{{path}}}?#{{{params}}}"
        {% end %}

        headers = {{headers}}

        # Build a body (if required)
        {% if body.is_a? NilLiteral || body.is_a? StringLiteral %}
          body = {{body}}
        {% else %}
          headers ||= HTTP::Headers.new
          headers["Content-Type"] = "application/json"
          body = JSON.build do |json|
            json.object do
              {% if body.id == :from_args.id %}
                # Map all non-default value args into the body, ignoring `id`
                # as this is universally used within the query path.
                {% for arg in @def.args.reject { |arg| arg.name == :id.id } %}
                  {%
                    # Module is a reserved word in crystal, remap mod -> module
                    name = if arg.name.id == :mod.id
                             "module"
                           else
                             arg.name.stringify
                           end
                  %}
                  {% if arg.default_value.is_a? Nop %}
                    json.field {{name}}, {{arg.name}}
                  {% else %}
                    json.field {{name}}, {{arg.name}} \
                      unless {{arg.name}} == {{arg.default_value}}
                  {% end %}
                {% end %}
              {% elsif body.is_a? NamedTupleLiteral || body.is_a? HashLiteral %}
                {% for key, val in body %}
                  json.field {{key.stringify}}, {{val}}
                {% end %}
              {% else %}
                {{raise "unsupported body type"}}
              {% end %}
            end
          end
        {% end %}
      {% end %}

      # Exec the request
      response = connection.{{method.id}} path, headers, body
      raise API::Error.from_response(response) unless response.success?
      \{% if model %}
        \{{model}}.from_json response.body
      \{% else %}
         if response.body.empty?
           JSON::Any.new nil
         else
           JSON.parse response.body
         end
      \{% end %}
    end
  {% end %}
end
