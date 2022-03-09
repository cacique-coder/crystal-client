require "./response"
require "./trigger"

module PlaceOS::Client::API::Models
  struct APIKey < Response
    include Timestamps

    # A universally unique identifier for the zone.
    getter id : String

    # A human readable identifier.
    getter name : String

    # The auth key, only returned on create
    getter x_api_key : String

    # Markdown formatted text that describes the zone.
    getter description : String?

    # API scopes
    getter scopes : Array(String) = [] of String

    # The permission level of the user
    getter permissions : ::PlaceOS::Model::UserJWT::Permissions

    getter user_id : String

    getter user : User

    getter authority_id : String

    getter authority : Authority
  end
end
