require "./endpoint"

module PlaceOS
  class Client::APIWrapper::OAuthApplications < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(OAuthApplication)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/oauth_apps"

    # List or search for applications.
    #
    # Results maybe filtered by specifying a query - *q* - to search across application
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
    # Up to *limit* application will be returned, with a paging based on *offset*.
    def search(
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0,
      authority : String? = nil
    )
      get base, params: from_args, as: Array(OAuthApplication)
    end

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
