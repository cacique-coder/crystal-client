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
      environment = {"PLACE_URI", "PLACE_EMAIL", "PLACE_PASSWORD", "PLACE_AUTH_CLIENT_ID", "PLACE_AUTH_SECRET"}.map do |key|
        ENV[key]? || abort "missing #{key} in environment"
      end
      uri, email, password, client_id, client_secret = environment

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
      @client_secret : String? = nil,
      # Allow for a token to be used directly (proxying auth)
      @token : OAuth2::AccessToken? = nil,
      @host_header : String? = nil,
      @insecure : Bool = false,
      @x_api_key : String? = nil
    )
      @uri = base_uri.is_a?(String) ? URI.parse(base_uri) : base_uri
      @api_wrapper = APIWrapper.new(@uri, @host_header, @insecure) do |http|
        authenticate(http)
      end
    end

    def authenticated?
      return true if @session || @x_api_key
      !(@email.nil? || @password.nil? || @client_id.nil? || @client_secret.nil?)
    end

    @session : OAuth2::Session? = nil
    private property token : OAuth2::AccessToken? = nil
    private getter authentication_lock : Mutex = Mutex.new

    protected def authenticate(client : HTTP::Client)
      # If a token is passed as part of client initialisation then we want
      # to use that as we are proxying the auth
      if x_api_key = @x_api_key
        client.before_request do |request|
          request.headers["X-API-Key"] = x_api_key
        end
      elsif @token && @session.nil?
        @token.try &.authenticate(client)
      else
        return unless authenticated?
        authentication_lock.synchronize do
          begin
            session.try &.authenticate(client)
          rescue OAuth2::Error
            # Reauthenticate if something went wrong with the refresh token
            @session = nil
            session.try &.authenticate(client)
          end
        end
      end
    end

    protected def session
      return @session.as(OAuth2::Session) unless @session.nil?
      client = OAuth2::Client.new(
        host: uri.host.as(String),
        port: uri.port,
        scheme: uri.scheme || "https",
        client_id: @client_id.as(String),
        client_secret: @client_secret.as(String),
        authorize_uri: AUTHORIZE_ENDPOINT,
        token_uri: TOKEN_ENDPOINT,
      )

      if @insecure && (uri.scheme.try(&.downcase) || "https") == "https"
        tls = OpenSSL::SSL::Context::Client.new
        tls.verify_mode = OpenSSL::SSL::VerifyMode::NONE
        client.http_client = HTTP::Client.new(uri.host.as(String), uri.port, tls)
      end

      token = client.get_access_token_using_resource_owner_credentials(
        @email.as(String),
        @password.as(String),
        "public",
      ).as(OAuth2::AccessToken::Bearer)

      @session = OAuth2::Session.new(client, token) do |refreshed_session|
        self.token = refreshed_session.access_token
      end

      @session
    end

    {% for component in %w(Authority Users Cluster Domains Drivers Modules Settings Systems Zones Ldap OAuth Saml OAuthApplications Root Metadata APIKeys) %}
    # Provide an object for managing {{component.id}}. See `PlaceOS::Client::APIWrapper::{{component.id}}`.
    def {{component.id.downcase}} : APIWrapper::{{component.id}}
      @{{component.id.downcase}} ||= APIWrapper::{{component.id}}.new(api_wrapper)
    end
    {% end %}
  end
end

require "./api_wrapper"
require "./api_wrapper/**"
