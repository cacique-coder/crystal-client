require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model Github Link: https://github.com/PlaceOS/models/blob/master/src/placeos-models/base/model.cr
  #
  struct System < Response
    include Timestamps

    # A universally unique identifier for the system.
    getter id : String

    # A human readable identifier.
    getter name : String

    # Markdown formatted text that describes the system.
    getter description : String?

    # List of features in the room for searching and filtering spaces.
    getter features : Set(String) = Set(String).new

    # Calendar URI that is associated with this system.
    getter email : String?

    # Flag for signifying the space as reservable.
    getter bookable : Bool

    getter display_name : String?
    getter type : String?

    # Number of people that can be accommodated in this space.
    getter capacity : Int32

    getter map_id : String?

    # need requiring placeos-model
    # @[JSON::Field(converter: Time::Location::Converter)]
    # getter timezone : Time::Location?

    # A URL linking to the primary interface for controlling this system.
    getter support_url : String?

    # Incrementing counter for handling stale updates.
    getter version : Int32

    # Expected number of fixed installation touch panels.
    getter installed_ui_devices : Int32

    # Zone IDs that this system is a member of.
    getter zones : Array(String)

    # Module ID's that this system contains.
    getter modules : Array(String)
  end
end
