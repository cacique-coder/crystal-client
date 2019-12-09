require "json"

# Metadata about the ACAEngine instance connected to.
#
# This provides information that may be of relevance for authentication or
# providing client-side configuration information.
struct ACAEngine::API::Models::Authority
  include JSON::Serializable

  # A universally unique identifier that represents the Authority.
  getter id : String

  # Human readable name
  getter name : String

  # FQDN or IP address this authority serves.
  @[JSON::Field(key: "dom")]
  getter domain : String

  # Authority description (markdown).
  getter description : String?

  # Path that clients should use for initiating authentication.
  getter login_url : String

  # Path that clients should use for revoking authentication.
  getter logout_url : String

  # Additional configuration / context for clients.
  getter config : Hash(String, ::JSON::Any)

  # Flag for if this client is currently authed.
  getter session : Bool

  # Flag for production status.
  getter production : Bool
end
