require "./endpoint"

module PlaceOS
  # TODO:
  # - search (index)
  # - get (show)
  # - create
  # - update
  class Client::APIWrapper::Users < Client::APIWrapper::Endpoint
    getter base : String = "#{API_ROOT}/users"

    def current
      get "#{base}/current", as: API::Models::User
    end
  end
end
