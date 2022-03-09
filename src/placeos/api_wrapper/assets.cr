require "../api/models/asset"
require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Assets < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Asset)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/assets"

    # Management
    ###########################################################################

    # Creates a new asset.
    def create(
      name : String,
      purchase_date : Time,
      identifier : String? = nil,
      purchase_price : Int32? = nil
    )
      post base, body: from_args, as: API::Models::Asset
    end

    # Updates asset attributes or configuration.
    def update(
      id : String,
      name : String? = nil,
      purchase_date : Time? = nil,
      identifier : String? = nil,
      purchase_price : Int32? = nil
    )
      put "#{base}/#{id}", body: from_args, as: API::Models::Asset
    end

    def asset_instances(id : String)
      get "#{base}/#{id}/asset_instances", as: Array(API::Models::AssetInstance)
    end

    # Search
    ###########################################################################

    # List or search for assets.
    #
    # Results maybe filtered by specifying a query - *q* - to search across asset
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
    # Up to *limit* assets will be returned, with a paging based on *offset*.
    #

    def search(
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0,
      parent : String? = nil
    )
      get base, params: from_args, as: Array(API::Models::Asset)
    end
  end
end
