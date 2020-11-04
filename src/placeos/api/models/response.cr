require "json"
require "uri"
require "placeos-models"

module PlaceOS::Client::API::Models
  # :nodoc:
  abstract struct Response
    include JSON::Serializable

    macro extended
      macro finished
        # Initializer based off {{@type.id}} properties
        def initialize(
        {% for arg in @type.instance_vars %}
          @{{arg.name}} : {{arg.type}}{% if arg.has_default_value? %} = {{arg.default_value.id}}{% end %},
        {% end %}
        )
        end
      end
    end
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
