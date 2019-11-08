require "json"
require "uri"
require "./role"

def URI.new(pull : JSON::PullParser)
  URI.parse pull.read_string
end

struct ACAEngine::API::Models::Module
  include JSON::Serializable

  # A universally unique identifier for the module.
  @[JSON::Field]
  getter id : String

  # The driver that defines this module.
  @[JSON::Field]
  getter dependency_id : String

  # The system this module is bound to (logic modules only).
  @[JSON::Field]
  getter control_sytem_id : String?

  # The engine node that this module runs on.
  @[JSON::Field]
  getter edge_id : String

  # IP address or resolvable hostname of the device this module connects to.
  @[JSON::Field]
  getter ip : String?

  # True if the device communicates securely.
  @[JSON::Field]
  getter tls : Bool?

  # Protocol uses UDP rather that TCP.
  @[JSON::Field]
  getter udp : Bool?

  # The TCP or UDP port that the associated device communicates on.
  @[JSON::Field]
  getter port : Int32?

  # If enabled, provides an ephemeral connection that disconnects during idle
  # periods.
  @[JSON::Field]
  getter makebreak : Bool

  # The based URI of the remote service (service modules only).
  @[JSON::Field]
  getter uri : URI?

  # The modules class name (Display, Lighting etc) if it should differ from the
  # default defined in the dependency.
  @[JSON::Field]
  getter custom_name : String?

  # JSON object representing the system's configuration.
  @[JSON::Field]
  getter settings : ::JSON::Any

  # Last update time.
  @[JSON::Field(converter: Time::EpochConverter)]
  getter updated_at : Time

  # System creation time.
  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time

  # The associated driver type.
  @[JSON::Field]
  getter role : Role

  # Markdown formatted text that describes this module.
  @[JSON::Field]
  getter notes : String?

  # Flag for connectivity state.
  @[JSON::Field]
  getter connected : Bool

  # Module start/stop state.
  @[JSON::Field]
  getter running : Bool

  # If enabled, system metrics ignore connectivity state.
  @[JSON::Field]
  getter ignore_connected : Bool

  # If enabled, system level start and stop actions are ignored. This is
  # recommended for modules shared by many systems (e.g. a lighting gateway).
  @[JSON::Field]
  getter ignore_startstop : Bool
end
