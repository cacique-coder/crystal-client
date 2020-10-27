require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model GitHub Link: https://github.com/PlaceOS/models/blob/master/src/placeos-models/trigger_instance.cr
  #
  struct TriggerInstance < Response
    # getter id : String
    getter control_system_id : String? = nil
    getter trigger_id : String? = nil
    getter zone_id : String? = nil

    getter enabled : Bool = true
    getter triggered : Bool = false
    getter important : Bool = false
    getter exec_enabled : Bool = false

    getter webhook_secret : String
    getter trigger_count : Int32 = 0
  end
end
