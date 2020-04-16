require "./response"
require "./trigger"

module PlaceOS::Client::API::Models
  struct Zone < Response
    include Timestamps

    # A universally unique identifier for the zone.
    getter id : String

    # A human readable identifier.
    getter name : String

    # Markdown formatted text that describes the zone.
    getter description : String?

    # Space seperated list of tags for categorizing the zone.
    getter tags : String?

    # List of trigger ID's to be applied to all systems that associate with this zone.
    getter triggers : Array(String)

    # Trigger data returned when param `complete` is `true`
    getter trigger_data : Array(Trigger)?
  end
end
