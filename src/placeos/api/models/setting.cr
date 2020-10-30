require "./response"

module PlaceOS::Client::API::Models
  struct Setting < Response
    getter id : String
    getter parent_id : String
    getter encryption_level : Int32
    getter settings_string : String
    getter keys : Array(String)
    getter parent_type : Int32

    @[JSON::Field(converter: Time::EpochConverter)]
    getter created_at : Time

    @[JSON::Field(converter: Time::EpochConverter)]
    getter updated_at : Time
  end
end
