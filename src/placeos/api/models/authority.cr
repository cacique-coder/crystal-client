require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model GitHub Link: https://github.com/PlaceOS/models/blob/master/src/placeos-models/authority.cr
  #
  # Metadata about the PlaceOS instance connected to.
  #
  # This provides information that may be of relevance for authentication or
  # providing client-side configuration information.
  struct Authority < Response
    # A universally unique identifier that represents the Authority.
    getter id : String

    # Human readable name
    getter name : String

    # FQDN or IP address this authority serves.
    getter domain : String

    # Authority description (markdown).
    getter description : String?

    # Path that clients should use for initiating authentication.
    getter login_url : String

    # Path that clients should use for revoking authentication.
    getter logout_url : String

    # Additional configuration / context for clients.
    getter config : Hash(String, ::JSON::Any)

    # Version of application
    getter version : String
  end
end
