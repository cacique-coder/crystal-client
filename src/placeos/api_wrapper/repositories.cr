require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Repositories < Client::APIWrapper::Endpoint
    getter base : String = "#{API_ROOT}/repositories"
  end
end
