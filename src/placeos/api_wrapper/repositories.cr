require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Repositories < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Repository)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/repositories"
  end
end
