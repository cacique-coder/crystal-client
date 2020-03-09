class PlaceOS::APIWrapper
  # List or search for zones.
  #
  # Results maybe filtered by specifying a query - *q* - to search across module
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
  def search_zones(q : String? = nil,
                   limit : Int = 20,
                   offset : Int = 0,
                   tags : String? = nil)
    get "/api/control/zones", params: from_args, as: QueryResult(Zone)
  end
end
