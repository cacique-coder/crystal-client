require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model GitHub Link: https://github.com/PlaceOS/models/blob/68b6de79003471398c53f363828ba6c1e3efae46/src/placeos-models/metadata.cr
  #
  struct Metadata < Response
    getter name : String
    getter description : String
    getter details : JSON::Any
    getter parent_id : String
  end
end
