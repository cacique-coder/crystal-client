require "./response"
require "./trigger"

module PlaceOS::Client::API::Models
  # PlaceOS::Model GitHub Link: https://github.com/PlaceOS/models/blob/master/src/placeos-models/zone.cr
  #
  struct Zone < Response
    include Timestamps

    # A universally unique identifier for the zone.
    getter id : String

    # A human readable identifier.
    getter name : String

    # A human readable identifier for displaying on interfaces
    getter display_name : String?

    # Geo-location string (lat,long) or any other location
    getter location : String?

    # Markdown formatted text that describes the zone.
    getter description : String?

    # Could be used as floor code or building code etc
    getter code : String?

    # Could be used as floor type or building type etc
    getter type : String?

    # Could be used as desk count for a level
    getter count : Int32

    # Could be used as people capacity
    getter capacity : Int32

    # Map identifier, could be a URL or id
    getter map_id : String?

    # getter parent_id : String?

    # Space seperated list of tags for categorizing the zone.
    getter tags : Array(String) = [] of String

    # List of trigger ID's to be applied to all systems that associate with this zone.
    getter triggers : Array(String)

    # Trigger data returned when param `complete` is `true`
    getter trigger_data : Array(Trigger)?
  end
end
