require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Root < Client::APIWrapper::Endpoint
    getter base : String = API_ROOT
  end
end
