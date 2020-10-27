require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model GitHub Link: https://github.com/PlaceOS/models/blob/master/src/placeos-models/oauth_authentication.cr
  #
  struct OAuthApplication < Response
    include Timestamps

    getter id : String

    getter name : String

    getter authority_id : String

    getter uid : String # client_id?

    getter secret : String # client_secret?

    # getter info_mappings : Hash(String, String)

    # getter authorize_params : Hash(String, String)

    # getter ensure_matching : Hash(String, Array(String))

    # getter site : String

    # getter authorize_url : String

    # getter token_method : String

    # getter auth_scheme : String

    # getter token_url : String

    getter scopes : String # scope ?

    # NOTE : Field does not exist in schema
    getter owner_id : String

    # NOTE : Field does not exist in schema
    getter redirect_uri : String

    # NOTE : Field does not exist in schema
    getter skip_authorization : Bool

    # NOTE : Field does not exist in schema
    getter confidential : Bool

    # NOTE : Field does not exist in schema
    @[JSON::Field(converter: Time::EpochConverter)]
    getter revoked_at : Time
  end
end
