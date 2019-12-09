require "json"

# Metadata about the ACAEngine instance connected to.
#
# This provides information that may be of relevance for authentication or
# providing client-side configuration information.
struct ACAEngine::API::Models::Authority
  include JSON::Serializable

  # A universally unique identifier that represents the Authority.
  @[JSON::Field]
  getter id : String

  # Human readable name
  @[JSON::Field]
  getter name : String

  # FQDN or IP address this authority serves.
  @[JSON::Field(key: "dom")]
  getter domain : String

  # Authority description (markdown).
  @[JSON::Field]
  getter description : String?

  # Path that clients should use for initiating authentication.
  @[JSON::Field]
  getter login_url : String

  # Path that clients should use for revoking authentication.
  @[JSON::Field]
  getter logout_url : String

  # Additional configuration / context for clients.
  @[JSON::Field]
  getter config : Hash(String, ::JSON::Any)

  # Flag for if this client is currently authed.
  @[JSON::Field]
  getter session : Bool

  # Flag for production status.
  @[JSON::Field]
  getter production : Bool
end
