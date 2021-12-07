require "../api/models/asset_instance"
require "./endpoint"

module PlaceOS
  class Client::APIWrapper::AssetInstances < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(AssetInstance)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/asset_instances"

    # Management
    ###########################################################################

    # Creates a new asset instance.
    def create(
      name : String,
      usage_start : Time,
      usage_end : Time
    )
      post base, body: from_args, as: API::Models::AssetInstance
    end

    # Updates asset instance attributes or configuration.
    def update(
      id : String,
      name : String? = nil,
      purchase_date : Time? = nil,
      identifier : String? = nil,
      purchase_price : Int32? = nil
    )
      put "#{base}/#{id}", body: from_args, as: API::Models::AssetInstance
    end

    # Search
    ###########################################################################

    # List or search for asset instances.
    #
    # Results maybe filtered by specifying a query - *q* - to search across asset instance
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
    # Up to *limit* asset instances will be returned, with a paging based on *offset*.
    #

    def search(
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0,
      parent : String? = nil
    )
      get base, params: from_args, as: Array(API::Models::AssetInstance)
    end
  end
end
