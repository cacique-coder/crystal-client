require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Domains < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Search(PlaceOS::Model::Authority)
    include Client::APIWrapper::Endpoint::Fetch(PlaceOS::Model::Authority)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/domains"

    __create_update_from_model__(PlaceOS::Model::Authority)
  end
end
