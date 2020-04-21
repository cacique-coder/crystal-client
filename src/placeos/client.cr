require "uri"

# Client for interfacing with PlaceOS.
#
# Provides API wrappers, models and abstractions over these for controlling,
# automating or interacting with PlaceOS instances and the environments they
# interface with.
module PlaceOS
  class Client
    VERSION       = {{ `shards version "#{__DIR__}"`.chomp.stringify.downcase }}
    API_ROOT      = "/api/engine/v2"
    AUTH_API_ROOT = "/api/auth"

    getter uri : URI
    getter api_wrapper : APIWrapper
    property auth_token : String

    # Creates a new `PlaceOS::Client`
    # Expects `PLACE_URI` and `PLACE_TOKEN` in the environment
    def self.from_environment_token
      uri = ENV["PLACE_URI"]? || abort "missing PLACE_URI in environment"
      token = ENV["PLACE_TOKEN"]? || abort "missing PLACE_TOKEN in environment"
      new(uri, token)
    end

    def initialize(base_uri : URI | String, @auth_token)
      @uri = base_uri.is_a?(String) ? URI.parse(base_uri) : base_uri
      @api_wrapper = APIWrapper.new(@uri)
    end

    {% for component in %w(Authority Cluster Domains Drivers Modules Settings Systems Zones Ldap OAuth Saml OAuthApplications) %}
    # Provide an object for managing {{component.id}}. See `PlaceOS::Client::APIWrapper::{{component.id}}`.
    def {{component.id.downcase}} : {{component.id}}
      @{{component.id.downcase}} ||= {{component.id}}.new(api_wrapper)
    end
    {% end %}
  end
end

require "./api_wrapper"
require "./api_wrapper/**"
