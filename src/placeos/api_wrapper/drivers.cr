require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Drivers < Client::APIWrapper::Endpoint
    getter base : String = "#{API_ROOT}/drivers"
  end
end
