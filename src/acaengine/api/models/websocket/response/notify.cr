require "json"
require "./meta"

# Asyncronous state update from an active binding.
struct ACAEngine::API::Models::Websocket::Response::Notify
  include JSON::Serializable

  # The identifier included with the original request.
  getter id : String | Int32 | Int64

  # New status value
  getter value : ::JSON::Any

  # Associated metadata.
  getter meta : Meta?
end
