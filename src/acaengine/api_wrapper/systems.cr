require "json"
require "../api/models/query_result"
require "../api/models/system"

class ACAEngine::APIWrapper
  # Retrieves systems.
  #
  # Results maybe filtered by specifying a *query* to search across system
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
  def systems(query : String? = nil, limit : Int? = nil, offset : Int? = nil)
    params = HTTP::Params.build do |param|
      param.add "q", query.to_s unless query.nil?
      param.add "limit", limit.to_s unless limit.nil?
      param.add "offset", offset.to_s unless offset.nil?
    end
    response = get "/api/control/systems?#{params}"
    QueryResult(System).from_json response.body
  end
end
