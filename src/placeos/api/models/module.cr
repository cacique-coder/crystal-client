require "./response"
require "./role"

module PlaceOS::Client::API::Models
  struct Module < Response
    include Timestamps

    # A universally unique identifier for the module.
    getter id : String

    # The driver that defines this module.
    getter driver_id : String

    # The system this module is bound to (logic modules only).
    getter control_sytem_id : String?

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
    # default defined in the driver.
    getter custom_name : String?

    # Driver's default name for the module
    getter name : String

    # The associated driver type.
    @[JSON::Field(converter: Enum::ValueConverter(PlaceOS::Client::API::Models::Role))]
    getter role : Role

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
end
