require "./response"

module PlaceOS::Client::API::Models
  struct Zone::Metadata < Response
    getter name : String?
    getter description : String?
    getter details : JSON::Any?
    getter zone_id : String?
  end
end
