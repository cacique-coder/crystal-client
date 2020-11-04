require "./endpoint"

module PlaceOS
  class Client::APIWrapper::OAuthApplications < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Search(OAuthApplication)
    include Client::APIWrapper::Endpoint::Fetch(OAuthApplication)
    # include Client::APIWrapper::Endpoint::Create
    # include Client::APIWrapper::Endpoint::Update
    include Client::APIWrapper::Endpoint::Destroy

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
      post base, body: from_args, as: OAuthApplication
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
      put "#{base}/#{id}", body: from_args, as: OAuthApplication
    end
  end
end
