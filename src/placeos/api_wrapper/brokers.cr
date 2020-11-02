require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Brokers < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Index(PlaceOS::Model::Broker)
    include Client::APIWrapper::Endpoint::Fetch(PlaceOS::Model::Broker)
    include Client::APIWrapper::Endpoint::Create(PlaceOS::Model::Broker)
    include Client::APIWrapper::Endpoint::Update(PlaceOS::Model::Broker)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/brokers"
  end
end
