require "json"

struct PlaceOS::API::Models::Websocket::Response::Meta
  include JSON::Serializable

  # The system ID.
  getter sys : String

  # Module name.
  getter mod : String

  # Module index.
  getter index : Int32

  # Name of the method or status key.
  getter name : String?
end
