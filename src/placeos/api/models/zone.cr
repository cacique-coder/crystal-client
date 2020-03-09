require "json"

struct PlaceOS::API::Models::Zone
  include JSON::Serializable

  # A universally unique identifier for the zone.
  getter id : String

  # A human readable identifier.
  getter name : String

  # Markdown formatted text that describes the zone.
  getter description : String?

  # Space seperated list of tags for categorizing the zone.
  getter tags : String?

  # JSON object representing the zone configuration.
  getter settings : Hash(String, ::JSON::Any)

  # List of trigger ID's to be applied to all systems that associate with this
  # zone.
  getter triggers : Array(String)

  # Zone creation time.
  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time
end
