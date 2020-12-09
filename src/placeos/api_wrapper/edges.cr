require "../api/models/edge"
require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Edges < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Edge)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/edges"

    # Management
    ###########################################################################

    # Creates a new edge.
    def create(
      name : String,
      description : String? = nil
    )
      post base, body: from_args, as: API::Models::Edge
    end

    # Updates edge attributes or configuration.
    def update(
      id : String,
      name : String? = nil,
      description : String? = nil
    )
      put "#{base}/#{id}", body: from_args, as: API::Models::Edge
    end

    # Retrieves a token for an edge.
    def token(
      id : String
    ) : String
      response = get "#{base}/#{id}/token", body: from_args, as: API::Models::Edge::Token
      response.token
    end

    # Search
    ###########################################################################

    # List or search for edges.
    #
    # Results maybe filtered by specifying a query - *q* - to search across model
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
    # Up to *limit* models will be returned, with a paging based on *offset*.
    def search(
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0
    )
      get base, params: from_args, as: Array(API::Models::Edge)
    end

    private getter client

    def initialize(@client : APIWrapper)
    end
  end
end
