require "json"

struct ACAEngine::API::Models::Ping
  include JSON::Serializable

  @[JSON::Field]
  getter host : String

  @[JSON::Field]
  getter pingable : Bool
end
