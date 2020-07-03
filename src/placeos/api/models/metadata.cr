require "./response"

module PlaceOS::Client::API::Models
  struct Metadata < Response
    getter name : String
    getter description : String
    getter details : JSON::Any
    getter parent_id : String
  end
end
