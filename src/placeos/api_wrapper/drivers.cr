require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Drivers < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Driver)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/drivers"

    # List or search for drivers.
    #
    # Results maybe filtered by specifying a query - *q* - to search across driver
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
    # Up to *limit* drivers will be returned, with a paging based on *offset*.
    def search(q : String? = nil, limit : Int = 20, offset : Int = 0)
      get base, params: from_args, as: Array(Driver)
    end

    def create(
      name : String,
      role : Role,
      commit : String,
      file_name : String,
      module_name : String,
      repository_id : String,
      default_uri : String?,
      default_port : Int32?,
      description : String?,
      ignore_connected : Bool?
    )
      post base, body: from_args, as: Driver
    end

    def update(
      id : String,
      name : String?,
      role : Role?,
      commit : String?,
      file_name : String?,
      module_name : String?,
      default_uri : String?,
      default_port : Int32?,
      description : String?,
      ignore_connected : Bool?
    )
      put "#{base}/#{id}", body: from_args, as: Driver
    end

    # Unique Actions
    def recompile(id : String)
      post "#{base}/#{id}/recompile"
    end

    def compiled(id : String)
      get "#{base}/#{id}/compiled"
    end
  end
end
