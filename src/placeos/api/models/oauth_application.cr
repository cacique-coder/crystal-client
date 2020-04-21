require "./response"

module PlaceOS::Client::API::Models
  struct OAuthApplication < Response
    include Timestamps
    getter id : String
    getter name : String
    getter uid : String
    getter secret : String
    getter scopes : String
    getter owner_id : String
    getter redirect_uri : String
    getter skip_authorization : Bool
    getter confidential : Bool
    @[JSON::Field(converter: Time::EpochConverter)]
    getter revoked_at : Time
  end
end
