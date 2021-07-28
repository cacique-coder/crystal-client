require "../api/models/zone"
require "./endpoint"

module PlaceOS
  class Client::APIWrapper::APIKeys < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(APIKey)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/api_keys"

    # Management
    ###########################################################################

    # Creates a new zone.
    def create(
      name : String,
      user_id : String,
      description : String? = nil,
      scopes : Array(String)? = nil,
      permissions : ::PlaceOS::Model::UserJWT::Permissions? = nil
    )
      post base, body: from_args, as: API::Models::APIKey
    end

    # Updates zone attributes or configuration.
    def update(
      id : String,
      name : String? = nil,
      user_id : String? = nil,
      description : String? = nil,
      scopes : Array(String)? = nil,
      permissions : ::PlaceOS::Model::UserJWT::Permissions? = nil
    )
      put "#{base}/#{id}", body: from_args, as: API::Models::APIKey
    end

    # Get a clear text version of the JWT token
    def inspect_jwt
      get "#{base}/inspect", as: ::PlaceOS::Model::UserJWT
    end

    # Search
    ###########################################################################

    # List or search for zones.
    #
    # Results maybe filtered by specifying a query - *q* - to search across zone
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
    # Up to *limit* zones will be returned, with a paging based on *offset*.
    #
    # Results my also also be limited to those associated with specific *tags*.
    def search(
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0,
      authority_id : String? = nil
    )
      get base, params: from_args, as: Array(API::Models::APIKey)
    end

    private getter client

    def initialize(@client : APIWrapper)
    end
  end
end
