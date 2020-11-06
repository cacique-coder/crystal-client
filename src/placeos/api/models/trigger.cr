require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model GitHub Link: https://github.com/PlaceOS/models/blob/master/src/placeos-models/trigger.cr
  #
  struct Trigger < Response
    getter id : String
    getter name : String
    getter description : String?
    getter control_system_id : String

    getter actions : Actions?
    getter conditions : Conditions?

    # In milliseconds
    getter debounce_period : Int32?
    getter important : Bool?

    getter enable_webhook : Bool?
    getter supported_methods : Array(String)?

    struct Actions < Response
      getter functions : Array(Function) = [] of PlaceOS::Client::API::Models::Trigger::Actions::Function
      getter mailers : Array(Email) = [] of PlaceOS::Client::API::Models::Trigger::Actions::Email

      struct Email < Response
        getter emails : Array(String)
        getter content : String
      end

      struct Function < Response
        getter mod : String
        getter method : String
        getter args : Hash(String, JSON::Any) = {} of String => JSON::Any
      end
    end

    struct Conditions < Response
      getter comparisons : Array(Comparison) = [] of PlaceOS::Client::API::Models::Trigger::Conditions::Comparison
      getter time_dependents : Array(TimeDependent) = [] of PlaceOS::Client::API::Models::Trigger::Conditions::TimeDependent

      struct Comparison < Response
        getter left : Value
        getter operator : String
        getter right : Value

        alias Value = StatusVariable | Constant

        # Constant value
        alias Constant = Int64 | Float64 | String | Bool

        # Status of a Module
        alias StatusVariable = NamedTuple(
          # Module that defines the status variable
          mod: String,
          # Unparsed hash of a status variable
          status: String,
          # Keys to look up in the module
          keys: Array(String),
        )

        OPERATORS = {
          "equal", "not_equal", "greater_than", "greater_than_or_equal",
          "less_than", "less_than_or_equal", "and", "or", "exclusive_or",
        }
      end

      struct TimeDependent < Response
        enum Type
          At
          Cron
        end

        getter type : Type

        @[JSON::Field(converter: Time::EpochConverter)]
        getter time : Time? = nil

        getter cron : String? = nil
      end
    end
  end
end
