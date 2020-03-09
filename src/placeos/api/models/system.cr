require "json"
require "uri"

def URI.new(pull : JSON::PullParser)
  URI.parse pull.read_string
end

struct PlaceOS::API::Models::System
  include JSON::Serializable

  # A universally unique identifier for the system.
  getter id : String

  # The engine node that this system operates from.
  getter edge_id : String

  # A human readable identifier.
  getter name : String

  # Zone IDs that this system is a member of.
  getter zones : Array(String)

  # Module ID's that this system contains.
  getter modules : Array(String)

  # Markdown formatted text that describes the system.
  getter description : String?

  # Calendar URI that is associated with this system.
  getter email : String?

  # Number of people that can be accommodated in this space.
  getter capacity : Int32

  # List of features in the room for searching and filtering spaces.
  getter features : String

  # Flag for signifying the space as reservable.
  getter bookable : Bool

  # Expected number of fixed installation touch panels.
  getter installed_ui_devices : Int32

  # JSON object representing the system's configuration.
  getter settings : Hash(String, ::JSON::Any)

  # System creation time.
  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time

  # A URL linking to the primary interface for controlling this system.
  getter support_url : URI?

  # Incrementing counter for handling stale updates.
  getter version : Int32
end
