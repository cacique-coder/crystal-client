require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Authority < Client::APIWrapper::Endpoint
    getter base : String = "#{AUTH_API_ROOT}/authority"

    # Gets the authority metadata for the attached instance.
    def fetch
      get base, as: PlaceOS::Model::Authority
    end
  end
end
