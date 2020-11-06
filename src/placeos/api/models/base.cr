require "./response"
require "placeos-models"

module PlaceOS::Client::API::Models
  {% for mdl in PlaceOS::Model::ModelBase.all_subclasses %}
    struct Client{{mdl.id}}
      include JSON::Serializable

      getter id : String? = nil

      {% for name, opts in mdl.constant("FIELDS") %}
        property {{name.id}} : {{opts[:klass]}} | Nil = nil
      {% end %}
    end
  {% end %}
end
