require "./endpoint"

module PlaceOS
  class Client::APIWrapper::OAuthApplications < Client::APIWrapper::Endpoint
    getter base : String = "#{API_ROOT}/oauth_apps"
  end
end
