require "placeos-models/utilities/encryption"

require "./response"

module PlaceOS::Client::API::Models
  struct Settings < Response
    getter encryption_level : Encryption::Level
    getter settings_string : String = "{}"
    getter keys : Array(String) = [] of String
    getter settings_id : String? = nil
    getter parent_id : String
  end
end
