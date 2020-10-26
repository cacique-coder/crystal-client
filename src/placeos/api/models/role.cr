module PlaceOS::Client::API::Models
  enum Role
    SSH       =  0
    Device    =  1
    Service   =  2
    Websocket =  3
    Logic     = 99

    def to_json(json)
      json.number(to_i)
    end
  end
end
