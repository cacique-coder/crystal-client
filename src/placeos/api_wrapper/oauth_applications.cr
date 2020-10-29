require "./endpoint"

module PlaceOS
  class Client::APIWrapper::OAuthApplications < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(PlaceOS::Model::DoorkeeperApplication)
    include Client::APIWrapper::Endpoint::Destroy
    include Client::APIWrapper::Endpoint::Search(PlaceOS::Model::DoorkeeperApplication)

    getter base : String = "#{API_ROOT}/oauth_apps"

    def create(
      name : String,
      uid : String? = nil,
      secret : String? = nil,
      scopes : String? = nil,
      owner_id : String? = nil,
      redirect_uri : String? = nil,
      skip_authorization : Bool? = nil,
      confidential : Bool? = nil,
      revoked_at : Time? = nil
    )
      post base, body: from_args, as: PlaceOS::Model::DoorkeeperApplication
    end

    def update(
      id : String,
      name : String? = nil,
      uid : String? = nil,
      secret : String? = nil,
      scopes : String? = nil,
      owner_id : String? = nil,
      redirect_uri : String? = nil,
      skip_authorization : Bool? = nil,
      confidential : Bool? = nil,
      revoked_at : Time? = nil
    )
      put "#{base}/#{id}", body: from_args, as: PlaceOS::Model::DoorkeeperApplication
    end
  end
end
