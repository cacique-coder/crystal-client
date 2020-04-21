require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Settings < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(API::Models::Settings)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/settings"
  end
end
