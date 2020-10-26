#  require "models/driver"

module PlaceOS::Client::API::Models
  # NOTE: active-model is having an issue with resolving a type.
  #       The obvious ideal is the alias below with `require "models/driver"`
  # alias Role = PlaceOS::Models::Driver::Role
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
