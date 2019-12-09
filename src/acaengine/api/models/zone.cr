require "json"

struct ACAEngine::API::Models::Zone
  include JSON::Serializable

  # A universally unique identifier for the zone.
  @[JSON::Field]
  getter id : String

  # A human readable identifier.
  @[JSON::Field]
  getter name : String

  # Markdown formatted text that describes the zone.
  @[JSON::Field]
  getter description : String?

  # Space seperated list of tags for categorizing the zone.
  @[JSON::Field]
  getter tags : String?

  # JSON object representing the zone configuration.
  @[JSON::Field]
  getter settings : Hash(String, ::JSON::Any)

  # List of trigger ID's to be applied to all systems that associate with this
  # zone.
  @[JSON::Field]
  getter triggers : Array(String)

  # Zone creation time.
  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time
end
