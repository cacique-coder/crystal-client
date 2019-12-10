require "json"
require "./meta"

struct ACAEngine::API::Models::Websocket::Response::Success
  include JSON::Serializable

  # The identifier included with the original request.
  getter id : String | Int32 | Int64

  # Associated metadata.
  getter meta : Meta?
end
