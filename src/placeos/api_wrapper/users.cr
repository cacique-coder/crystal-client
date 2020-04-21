require "./endpoint"

module PlaceOS
  # TODO:
  # - search (index)
  # - create
  # - update
  class Client::APIWrapper::Users < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(User)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/users"

    def current
      get "#{base}/current", as: User
    end
  end
end
