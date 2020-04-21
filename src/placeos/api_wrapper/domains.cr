require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Domains < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Authority)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/domains"
  end
end
