require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Repositories < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Repository)
    include Client::APIWrapper::Endpoint::Destroy
    include Client::APIWrapper::Endpoint::Search(Repository)

    getter base : String = "#{API_ROOT}/repositories"

    def create(
      name : String,
      uri : String,
      repo_type : String,
      username : String,
      password : String,
      key : String,
      folder_name : String?,
      description : String?,
      commit_hash : String?
    )
      post base, body: from_args, as: Repository
    end

    def update(
      id : String,
      username : String,
      password : String,
      key : String,
      name : String?,
      uri : String?,
      repo_type : String?,
      folder_name : String?,
      description : String?,
      commit_hash : String?
    )
      # id not defined, what should I used, or define it somewhere else?
      put "#{base}/#{id}", body: from_args, as: Repository
    end

    # Unique Actions
    def pull(id : String)
      post "#{base}/#{id}/pull"
    end

    def loaded_interfaces
      get "#{base}/interfaces"
    end

    def drivers(id : String)
      get "#{base}/#{id}/drivers"
    end

    def commits(id : String, count : Int32?, driver : String?)
      get "#{base}/#{id}/commits", params: from_args
    end

    def details(id : String, driver : String, commit : String)
      get "#{base}/#{id}/details", params: from_args
    end

    def branches(id : String)
      get "#{base}/#{id}/branches"
    end
  end
end
