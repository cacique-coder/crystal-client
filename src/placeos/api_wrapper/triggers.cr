require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Triggers < Client::APIWrapper::Endpoint
    getter base : String = "#{API_ROOT}/triggers"
  end
end
