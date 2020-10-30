require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Domains < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(PlaceOS::Model::Authority)
    include Client::APIWrapper::Endpoint::Destroy
    include Client::APIWrapper::Endpoint::Search(PlaceOS::Model::Authority)

    getter base : String = "#{API_ROOT}/domains"

    def create(
      name : String,
      domain : String,
      description : String?,
      login_url : String?,
      logout_url : String?,
      internals : Hash(String, JSON::Any)?,
      config : Hash(String, JSON::Any)?
    )
      post base, body: from_args, as: PlaceOS::Model::Authority
    end

    def update(
      id : String,
      name : String?,
      domain : String?,
      description : String?,
      login_url : String?,
      logout_url : String?,
      internals : Hash(String, JSON::Any)?,
      config : Hash(String, JSON::Any)?
    )
      put "#{base}/#{id}", body: from_args, as: PlaceOS::Model::Authority
    end
  end
end
