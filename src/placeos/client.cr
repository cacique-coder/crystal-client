require "uri"
require "oauth2"

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

    private AUTHORIZE_ENDPOINT = "/auth/oauth/authorize"
    private TOKEN_ENDPOINT     = "/auth/oauth/token"

    getter uri : URI
    getter api_wrapper : APIWrapper

    delegate :close, to: api_wrapper

    def self.from_environment_user
      environment = {"PLACE_EMAIL", "PLACE_PASSWORD", "PLACE_AUTH_CLIENT_ID", "PLACE_AUTH_SECRET"}.map do |key|
        ENV[key]? || abort "missing #{key} in environment"
      end
      email, password, client_id, client_secret = environment

      new(uri, email: email, password: password, client_id: client_id, client_secret: client_secret)
    end

    def self.from_environment_user
      client = self.from_environment_user
      yield client
    ensure
      client.close
    end

    def initialize(
      base_uri : URI | String,
      @email : String? = nil,
      @password : String? = nil,
      @client_id : String? = nil,
      @client_secret : String? = nil
    )
      @uri = base_uri.is_a?(String) ? URI.parse(base_uri) : base_uri
      @api_wrapper = APIWrapper.new(@uri, token)
    end

    protected def token
      if (email = @email) && (password = @password) && (client_id = @client_id) && (client_secret = @client_secret)
        client = OAuth2::Client.new(
          host: uri.host.as(String),
          port: uri.port,
          scheme: uri.scheme || "https",
          client_id: client_id,
          client_secret: client_secret,
          authorize_uri: AUTHORIZE_ENDPOINT,
          token_uri: TOKEN_ENDPOINT,
        )

        client.get_access_token_using_resource_owner_credentials(
          email,
          password,
          "public",
        ).as(OAuth2::AccessToken::Bearer)
      end
    end

    {% for component in %w(Authority Cluster Domains Drivers Modules Settings Systems Zones Ldap OAuth Saml OAuthApplications) %}
    # Provide an object for managing {{component.id}}. See `PlaceOS::Client::APIWrapper::{{component.id}}`.
    def {{component.id.downcase}} : APIWrapper::{{component.id}}
      @{{component.id.downcase}} ||= APIWrapper::{{component.id}}.new(api_wrapper)
    end
    {% end %}
  end
end

require "./api_wrapper"
require "./api_wrapper/**"
