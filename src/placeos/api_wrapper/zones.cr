require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Zones < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(PlaceOS::Model::Zone)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/zones"

    # Interaction
    ###########################################################################

    def execute(
      id : String,
      method : String,
      module_name : String,
      index : Int32 = 1,
      args = nil
    )
      post "#{base}/#{id}/#{module_name}_#{index}/#{method}", body: args, as: PlaceOS::Model::Zone
    end

    # Management
    ###########################################################################

    # Creates a new zone.
    def create(
      name : String,
      description : String? = nil,
      tags : Array(String)? = nil,
      settings : Settings? = nil,
      triggers : Array(String)? = nil
    )
      post base, body: from_args, as: PlaceOS::Model::Zone
    end

    # Updates zone attributes or configuration.
    def update(
      id : String,
      name : String? = nil,
      description : String? = nil,
      tags : Array(String)? = nil,
      settings : Settings? = nil,
      triggers : Array(String)? = nil
    )
      put "#{base}/#{id}", body: from_args, as: PlaceOS::Model::Zone
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
      parent : String? = nil,
      tags : Array(String) | String? = nil
    )
      get base, params: from_args, as: Array(PlaceOS::Model::Zone)
    end

    # Unique Actions
    def trigger(id : String)
      get "#{base}/#{id}/triggers", as: PlaceOS::Model::Zone
    end

    private getter client

    def initialize(@client : APIWrapper)
    end
  end
end
