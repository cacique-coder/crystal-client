require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Domains < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Authority)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/domains"

    # CRUD Actions
    def search(
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0
    )
      get base, params: from_args, as: Array(Authority)
    end

    def create(
      name : String,
      domain : String,
      description : String?,
      login_url : String?,
      logout_url : String?,
      internals : Hash(String, JSON::Any)?,
      config : Hash(String, JSON::Any)?
    )
      post base, body: from_args, as: Authority
    end

    def update(
      name : String?,
      domain : String?,
      description : String?,
      login_url : String?,
      logout_url : String?,
      internals : Hash(String, JSON::Any)?,
      config : Hash(String, JSON::Any)?
    )
      put "#{base}/#{id}", body: from_args, as: Authority
    end
  end
end
