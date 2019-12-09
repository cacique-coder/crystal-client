require "json"

class ACAEngine::APIWrapper
  # Settings type accepted by all endpoints.
  alias Settings = Hash(String, ::JSON::Any | ::JSON::Any::Type)
end
