require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Cluster < Client::APIWrapper::Endpoint
    getter base : String = "#{API_ROOT}/cluster"
  end
end
