require "json"
require "../api/models/query_result"
require "../api/models/system"

class ACAEngine::APIWrapper
  # Retrieves systems.
  #
  # Results maybe filtered by specifying a query - *q* - to search across system
  # attributes. A small query language is supported within this:
  #
  # Operator | Action
  # -------- | ------
  # `+`      | Matches both terms
  # `|`      | Matches either terms
  # `-`      | Negates a single token
  # `"`      | Wraps tokens to form a phrase
  # `(`  `)` | Provide precedence
  # `~N`     | Specifices edit distance (fuziness) after a word
  # `~N`     | Specifies slop amount (deviation) after a phrase
  #
  # Up to *limit* systems will be returned, with a paging based on *offset*.
  def systems(q : String? = nil, limit : Int? = nil, offset : Int? = nil)
    response = get "/api/control/systems?#{params_from_args}"
    QueryResult(System).from_json response.body
  end

  # Creates a new system.
  #
  # Systems must be given a unique *name* within the ACAEngine instance they are
  # running from. Additionally, a system must be a member of at least one
  # *zone*. All other attributes are optional at the time of creation.
  def create_system(name : String,
                    zones : Array(String),
                    edge_id : String? = nil,
                    description : String? = nil,
                    email : String? = nil,
                    capacity : Int = 0,
                    bookable : Bool = false,
                    installed_ui_devices : Int = 0,
                    modules : Array(String) = [] of String,
                    settings : String? = nil,
                    support_url : String? = nil)
    response = post "/api/control/systems", body: json_from_args
    System.from_json response.body
  end
end
