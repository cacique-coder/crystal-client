require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Authority < Client::APIWrapper::Endpoint
    getter base : String = "/api/auth/authority"

    # Gets the authority metadata for the attached instance.
    def fetch
      get base, as: API::Models::Authority
    end
  end
end
