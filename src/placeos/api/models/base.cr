require "./response"

module PlaceOS::Client::API::Models
  # # HELPERS
  # PlaceOS::Model::Comparison Types
  alias Value = StatusVariable | Constant
  alias Constant = Int64 | Float64 | String | Bool
  alias StatusVariable = NamedTuple(
    # Module that defines the status variable
    mod: String,
    # Unparsed hash of a status variable
    status: String,
    # Keys to look up in the module
    keys: Array(String),
  )

  # Converters Not To Use
  FORBID_CONVERTERS = ["JSON::Any::StringConverter"]

  # # Main Macro
  {% for subclasses in [PlaceOS::Model::ModelBase.all_subclasses, PlaceOS::Model::SubModel.all_subclasses] %}
    {% for mdl in subclasses %}
      struct {{mdl.name.id.split("::")[-1].id}} < Response
        {% if subclasses == PlaceOS::Model::SubModel %}
          include Timestamps
        {% end %}

        getter id : String? = nil

        {% for name, opts in mdl.constant("FIELDS") %}
          {% if opts[:mass_assign] == true %}
            {% if opts[:converter] && !FORBID_CONVERTERS.includes?(opts[:converter].resolve.stringify) %}
              @[JSON::Field(converter: {{opts[:converter]}})]
            {% end %}
            property {{name.id}} : {{opts[:klass]}}?
          {% end %}
        {% end %}
      end
    {% end %}
  {% end %}
end
