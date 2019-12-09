require "json"

struct ACAEngine::API::Models::Ping
  include JSON::Serializable

  getter host : String

  getter pingable : Bool
end
