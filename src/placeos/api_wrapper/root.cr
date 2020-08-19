require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Root < Client::APIWrapper::Endpoint
    getter base : String = API_ROOT

    # send data to listening drivers
    def signal(
      channel : String,
      payload
    )
      post "#{base}/signal?channel=#{channel}", body: payload
    end

    def version
      get "#{base}/version", as: API::Models::Version
    end
  end
end
