require "./response"

module PlaceOS::Client::API::Models
  # Describes an edge node
  struct Edge < Response
    include Timestamps

    # A universally unique identifier for the module.
    getter id : String

    # A descriptive name of the node
    getter name : String

    # The secret used to connect authorize this node
    getter secret : String

    # Markdown formatted text describing the node
    getter description : String

    # A token response from the API
    struct Token < Response
      getter token : String
    end
  end
end
