class ACAEngine::APIWrapper
  # List or search for modules.
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
  # Up to *limit* systems will be returned, with a paging based on *offset*.
  #
  # Results my also also be limited to those associated with a specific
  # *system_id*, that are instances of a *dependency_id*, or any combination of
  # these.
  def search_modules(q : String? = nil,
              limit : Int = 20,
              offset : Int = 0,
              system_id : String? = nil,
              dependency_id : String? = nil)
    get "/api/control/modules", params: from_args, as: QueryResult(Module)
  end
end
