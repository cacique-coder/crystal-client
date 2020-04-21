require "../endpoint"
require "../../api/models/auths/*"

module PlaceOS
  abstract class Client::APIWrapper::AuthBase(Model) < Client::APIWrapper::Endpoint
    # Gets the authority metadata for the attached instance.
    def fetch
      get base, as: Model
    end

    # List or search.
    #
    # Results maybe filtered by specifying a query - *q* - to search across
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
    # Up to *limit* documents will be returned, with a paging based on *offset*.
    def search(
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0,
      authority_id : String? = nil
    )
      get base, params: from_args, as: Array(Model)
    end

    def update(**args)
      put "#{base}/#{id}", body: from_args, as: Model
    end

    def create(**args) : Model
      post base, body: from_args, as: Model
    end

    def destroy(id : String)
      delete base + "/#{id}"
      nil
    end
  end
end
