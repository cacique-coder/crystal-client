require "json"
require "uri"
require "placeos-models"

module PlaceOS::Client::API::Models
  # :nodoc:
  abstract struct Response
    include JSON::Serializable

    private module Init
      macro finished
        macro included
          # Initializer based off {{@type.id}} properties
          def initialize(@name : String
            {% for arg in @type.instance_vars.reject &.has_default_value? %}
              @{{arg.name}} : {{arg.type}},
            {% end %}
            {% for arg in @type.instance_vars.select &.has_default_value? %}
              @{{arg.name}} : {{arg.type}} = {{arg.default_value.id}},
            {% end %}
          )
          end
        end
      end
    end

    include Init
  end

  module Timestamps
    # Creation time.
    @[JSON::Field(converter: Time::EpochConverter)]
    getter created_at : Time

    # Update time.
    @[JSON::Field(converter: Time::EpochConverter)]
    getter updated_at : Time
  end
end

# :nodoc:
class URI
  def self.new(pull : JSON::PullParser)
    URI.parse pull.read_string
  end
end
