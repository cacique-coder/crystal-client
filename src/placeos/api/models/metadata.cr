require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model GitHub Link: https://github.com/PlaceOS/models/blob/master/src/placeos-models/metadata.cr
  #
  struct Metadata < Response
    getter name : String
    getter description : String
    getter details : JSON::Any
    getter parent_id : String
  end
end
