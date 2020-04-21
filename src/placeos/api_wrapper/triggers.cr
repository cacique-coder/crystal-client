require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Triggers < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Trigger)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/triggers"
  end
end
