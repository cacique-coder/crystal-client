require "json"

struct PlaceOS::Client::API::Models::Websocket::Request
  include JSON::Serializable

  enum Type
    Bind
    Unbind
    Exec
    Debug
    Ignore
  end

  # A unique identifier to associate with the command. This will be returned as
  # part of the response.
  getter id : String | Int32 | Int64

  # The command type.
  getter cmd : Type

  # The system identified the command targets.
  getter sys : String

  # The module name the command targets.
  getter mod : String

  # The module index the command targets. Defaults to 1.
  getter index : Int32?

  # Name of the status variable of method being interacted with.
  getter name : String

  # Associated arguments for the command.
  getter args : Array(::JSON::Any::Type)?
end
