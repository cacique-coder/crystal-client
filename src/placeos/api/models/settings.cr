require "placeos-models/utilities/encryption"

require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model GitHub Link: https://github.com/PlaceOS/models/blob/master/src/placeos-models/settings.cr
  #
  struct Settings < Response
    getter id : String
    getter encryption_level : Encryption::Level
    getter settings_string : String = "{}"
    getter keys : Array(String) = [] of String
    getter settings_id : String? = nil
    getter parent_id : String
    getter parent_type : ParentType
  end

  enum ParentType
    ControlSystem
    Driver
    Module
    Zone
  end
end
