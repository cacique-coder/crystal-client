require "./response"

module PlaceOS::Client::API::Models
  struct Ping < Response
    getter host : String
    getter pingable : Bool
    getter warning : String?
    getter exception : String?
  end
end
