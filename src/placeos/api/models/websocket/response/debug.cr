require "json"
require "./meta"

struct PlaceOS::Client::API::Models::Websocket::Response::Debug
  include JSON::Serializable

  enum Level
    Unknown
    Fatal
    Error
    Warn
    Info
    Debug
  end

  # The identifier included with the original request.
  getter id : String | Int32 | Int64

  # ID of the module the event originated from.
  getter mod : String

  # Class of the originating message source.
  getter klass : String

  # Message verbosity level.
  getter level : Level

  # Log message.
  getter msg : String
end
