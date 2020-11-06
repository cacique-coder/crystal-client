require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model::Comparison Types
  ###
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
  ###

  {% for subclasses in [PlaceOS::Model::ModelBase.all_subclasses, PlaceOS::Model::SubModel.all_subclasses] %}
    {% for mdl in subclasses %}
      struct {{mdl.name.id.split("::")[-1].id}} < Response
        {% if subclasses == PlaceOS::Model::SubModel %}
          include Timestamps
        {% end %}

        getter id : String? = nil

        {% for name, opts in mdl.constant("FIELDS") %}
          {% if opts[:mass_assign] == true %}
            {% if opts[:converter] %}
              @[JSON::Field(converter: {{opts[:converter]}})]
            {% end %}
            property {{name.id}} : {{opts[:klass]}}?
          {% end %}
        {% end %}
      end
    {% end %}
  {% end %}
end

# This model does not conform with the standard above
module PlaceOS::Client::API::Models
  struct Metadata < Response
    getter name : String
    getter description : String
    # This field does not use the converter declared in FIELDS constant
    getter details : JSON::Any
    getter parent_id : String
  end
end
