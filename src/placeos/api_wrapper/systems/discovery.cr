class PlaceOS::APIWrapper
  # List or search for systems.
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
  # `(`  `)` | Provides precedence
  # `~N`     | Specifies edit distance (fuzziness) after a word
  # `~N`     | Specifies slop amount (deviation) after a phrase
  #
  # Up to *limit* systems will be returned, with a paging based on *offset*.
  def search_systems(q : String? = nil, limit : Int = 20, offset : Int = 0)
    get "/api/control/systems", params: from_args, as: QueryResult(System)
  end
end
