require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Settings < Client::APIWrapper::Endpoint
    getter base : String = "#{API_ROOT}/settings"
  end
end
