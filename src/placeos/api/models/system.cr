require "./response"

module PlaceOS::Client::API::Models
  struct System < Response
    include Timestamps

    # A universally unique identifier for the system.
    getter id : String

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

    # an alternative to the full name that is easier to read.
    getter display_name : String?

    # the room identification code, like 3-04 etc.
    getter code : String?

    # the system type, like a small meeting room etc.
    getter type : String?

    # a map identifier that can be used to locate this system.
    getter map_id : String?

    # Number of people that can be accommodated in this space.
    getter capacity : Int32

    # List of features in the room for searching and filtering spaces.
    getter features : Set(String) = Set(String).new

    # Flag for signifying the space as reservable.
    getter bookable : Bool

    # Expected number of fixed installation touch panels.
    getter installed_ui_devices : Int32

    # A URL linking to the primary interface for controlling this system.
    getter support_url : String?

    # Incrementing counter for handling stale updates.
    getter version : Int32
  end
end
