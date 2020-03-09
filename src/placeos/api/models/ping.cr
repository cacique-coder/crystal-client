require "json"

struct PlaceOS::API::Models::Ping
  include JSON::Serializable

  getter host : String

  getter pingable : Bool
end
