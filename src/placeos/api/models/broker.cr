require "./response"

module PlaceOS::Client::API::Models
  struct Broker < Response
    getter id : String
    getter name : String
    getter description : String
    getter host : String
    # TODO
  end
end
