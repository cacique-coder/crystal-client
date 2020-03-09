require "json"

struct PlaceOS::API::Models::Websocket::Response
  enum Type
    Success
    Error
    Notify
    Debug

    def model
      {% begin %}
        case self
        {% for type in @type.constants %}
        when {{type}} then Response::{{type}}
        {% end %}
        else
          # Will never happen, but required to stop nil for sneaking into the
          # returned type union.
          raise ""
        end
      {% end %}
    end
  end

  # Parses a websocket response into a concrete response type.
  #
  # FIXME: currently this is parsing twice - this is a quick hack to get things
  # going. When time allows this should be refactored to work as a single pass,
  # or provide a more efficient method for identifying the message type.
  def self.from_json(input)
    json = JSON.parse input
    type = Type.parse json["type"].as_s
    type.model.from_json input
  end
end
