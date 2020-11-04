require "./endpoint"

# missing model?

module PlaceOS
  class Client::APIWrapper::Cluster < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Search(Cluster)
    include Client::APIWrapper::Endpoint::Fetch(Cluster)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/cluster"
  end
end
