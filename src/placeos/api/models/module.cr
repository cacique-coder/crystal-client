require "json"
require "uri"
require "./role"

def URI.new(pull : JSON::PullParser)
  URI.parse pull.read_string
end

struct PlaceOS::API::Models::Module
  include JSON::Serializable

  # A universally unique identifier for the module.
  getter id : String

  # The driver that defines this module.
  getter dependency_id : String

  # The system this module is bound to (logic modules only).
  getter control_sytem_id : String?

  # The engine node that this module runs on.
  getter edge_id : String

  # IP address or resolvable hostname of the device this module connects to.
  getter ip : String?

  # True if the device communicates securely.
  getter tls : Bool?

  # Protocol uses UDP rather that TCP.
  getter udp : Bool?

  # The TCP or UDP port that the associated device communicates on.
  getter port : Int32?

  # If enabled, provides an ephemeral connection that disconnects during idle
  # periods.
  getter makebreak : Bool

  # The based URI of the remote service (service modules only).
  getter uri : URI?

  # The modules class name (Display, Lighting etc) if it should differ from the
  # default defined in the dependency.
  getter custom_name : String?

  # JSON object representing the system's configuration.
  getter settings : Hash(String, ::JSON::Any)

  # Last update time.
  @[JSON::Field(converter: Time::EpochConverter)]
  getter updated_at : Time

  # System creation time.
  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time

  # The associated driver type.
  getter role : Role

  # Markdown formatted text that describes this module.
  getter notes : String?

  # Flag for connectivity state.
  getter connected : Bool

  # Module start/stop state.
  getter running : Bool

  # If enabled, system metrics ignore connectivity state.
  getter ignore_connected : Bool

  # If enabled, system level start and stop actions are ignored. This is
  # recommended for modules shared by many systems (e.g. a lighting gateway).
  getter ignore_startstop : Bool
end
