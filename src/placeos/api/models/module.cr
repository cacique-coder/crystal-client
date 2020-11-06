require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model GitHub Link: https://github.com/PlaceOS/models/blob/master/src/placeos-models/module.cr
  #
  struct Module < Response
    include Timestamps

    # A universally unique identifier for the module.
    getter id : String

    # The driver that defines this module.
    getter driver_id : String?

    # The system this module is bound to (logic modules only).
    getter control_sytem_id : String?

    getter edge_id : String?

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
    getter makebreak : Bool? # ? or no ?

    # The based URI of the remote service (service modules only).
    getter uri : URI?

    # The modules class name (Display, Lighting etc) if it should differ from the
    # default defined in the driver.
    getter custom_name : String?

    # Driver's default name for the module
    getter name : String? # ? or no ?

    # The associated driver type.
    getter role : PlaceOS::Model::Driver::Role? # ? or no ?

    # Flag for connectivity state.
    getter connected : Bool? # ? or no ?

    # Module start/stop state.
    getter running : Bool? # ? or no ?

    # If enabled, system metrics ignore connectivity state.
    getter ignore_connected : Bool? # ? or no ?

    # If enabled, system level start and stop actions are ignored. This is
    # recommended for modules shared by many systems (e.g. a lighting gateway).
    getter ignore_startstop : Bool? # ? or no ?
  end
end
