require "./response"

module PlaceOS::Client::API::Models
  struct Trigger < Response
    getter name : String
    getter description : String
    getter control_system_id : String

    # getter actions : Trigger::Actions
    # getter conditions : Trigger::Conditions

    # In milliseconds
    getter debounce_period : Int32
    getter important : Bool

    getter enable_webhook : Bool
    getter supported_methods : Array(String)
  end
end
