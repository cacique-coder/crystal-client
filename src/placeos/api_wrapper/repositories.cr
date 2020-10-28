require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Repositories < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Repository)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/repositories"

    # CRUD Actions
    # Search
    ###########################################################################

    # List or search for modules.
    #
    # Results maybe filtered by specifying a query - *q* - to search across module
    # attributes. A small query language is supported within this:
    #
    # Operator | Action
    # -------- | ------
    # `+`      | Matches both terms
    # `|`      | Matches either terms
    # `-`      | Negates a single token
    # `"`      | Wraps tokens to form a phrase
    # `(`  `)` | Provides precedence
    # `~N`     | Specifies edit distance (fuzziness) after a word
    # `~N`     | Specifies slop amount (deviation) after a phrase
    #
    # Up to *limit* systems will be returned, with a paging based on *offset*.
    #
    # Results my also also be limited to those associated with a specific
    # *system_id*, that are instances of a *driver_id*, or any combination of
    # these.
    def search(
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0
    )
      get base, params: from_args, as: Array(Repository)
    end

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
