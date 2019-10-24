require "json"
require "uri"

def URI.new(pull : JSON::PullParser)
  URI.parse pull.read_string
end

struct ACAEngine::API::Models::System
  include JSON::Serializable

  # A universally unique identifier for the system.
  @[JSON::Field]
  getter id : String

  # A human readable identifier.
  @[JSON::Field]
  getter name : String

  # Zone IDs that this system is a member of.
  @[JSON::Field]
  getter zones : Array(String)

  # Module ID's that this system contains.
  @[JSON::Field]
  getter modules : Array(String)

  # Markdown formatted text that describes the system.
  @[JSON::Field]
  getter description : String?

  # Calendar URI that is associated with this system.
  @[JSON::Field]
  getter email : String?

  # Number of people that can be accommodated in this space.
  @[JSON::Field]
  getter capacity : Int32

  # List of features in the room for searching and filtering spaces.
  @[JSON::Field]
  getter features : String

  # Flag for signifying the space as reservable.
  @[JSON::Field]
  getter bookable : Bool

  # Expected number of fixed installation touch panels.
  @[JSON::Field]
  getter installed_ui_devices : Int32

  # JSON object representing the system's configuration.
  @[JSON::Field]
  getter settings : ::JSON::Any

  # System creation time.
  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time

  # A URL linking to the primary interface for controlling this system.
  @[JSON::Field]
  getter support_url : URI?

  # Incrementing counter for handling stale updates.
  @[JSON::Field]
  getter version : Int32
end
