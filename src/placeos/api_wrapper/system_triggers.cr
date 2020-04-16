require "./endpoint"

module PlaceOS
  class Client::APIWrapper::SystemTriggers < Client::APIWrapper::Endpoint
    # SystemTriggers are embedded beneath a systems route
    getter base : String = "#{API_ROOT}/systems"
  end
end
