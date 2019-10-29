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
end
