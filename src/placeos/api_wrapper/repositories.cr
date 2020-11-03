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
      # This can be improved later
      repo_type : Repository::Type,
      username : String? = "",
      password : String? = "",
      key : String? = "",
      folder_name : String? = "",
      description : String? = "",
      commit_hash : String? = ""
    )
      post base, body: from_args, as: Repository
    end

    def update(
      id : String,
      username : String?,
      password : String?,
      key : String?,
      name : String?,
      uri : String?,
      # This can be improved later
      repo_type : Repository::Type?,
      folder_name : String?,
      description : String?,
      commit_hash : String?
    )
      # id not defined, what should I used, or define it somewhere else?
      put "#{base}/#{id}", body: from_args, as: Repository
    end

    # Unique Actions
    def pull(id : String)
      post "#{base}/#{id}/pull", as: NamedTuple(commit_hash: String)
    end

    def loaded_interfaces
      get "#{base}/interfaces", as: NamedTuple(backoffice: String)
    end

    def drivers(id : String)
      get "#{base}/#{id}/drivers", as: Array(Path)
    end

    def commits(id : String, count : Int32? = nil, driver : String? = nil)
      get "#{base}/#{id}/commits", params: from_args, as: Array(NamedTuple(commit: String, date: Time, author: String, subject: String))
    end

    def details(id : String, driver : String, commit : String)
      get "#{base}/#{id}/details", params: from_args # spec and type casting requires rest-api specs
    end

    def branches(id : String)
      get "#{base}/#{id}/branches" # spec and type casting requires rest-api specs
    end
  end
end
