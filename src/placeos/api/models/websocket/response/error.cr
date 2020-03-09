require "json"

struct PlaceOS::API::Models::Websocket::Response::Error
  include JSON::Serializable

  enum Code
    ParseError
    BadRequest
    AccessDenied
    RequestFailed
    UnknownCommand
    SystemNotFound
    ModuleNotFound
    UnexpectedFailure
  end

  # The identifier included with the original request.
  getter id : String | Int32 | Int64

  # Error type.
  getter code : Code

  # Additional error info.
  getter msg : String
end
