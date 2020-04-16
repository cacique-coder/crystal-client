require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Domains < Client::APIWrapper::Endpoint
    getter base : String = "#{API_ROOT}/domains"
  end
end
