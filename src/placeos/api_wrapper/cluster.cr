require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Cluster < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Cluster)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/cluster"

    # CRUD Actions
    def search(
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0
    )
      get base, params: from_args, as: Array(Cluster)
    end
  end
end
