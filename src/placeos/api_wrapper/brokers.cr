require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Brokers < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Index(Broker)
    include Client::APIWrapper::Endpoint::Fetch(Broker)
    include Client::APIWrapper::Endpoint::Create(Broker)
    include Client::APIWrapper::Endpoint::Update(Broker)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/brokers"
  end
end
