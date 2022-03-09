require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Users < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Search(User)
    include Client::APIWrapper::Endpoint::Fetch(User)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/users"

    def create(
      authority_id : String,
      name : String,
      password : String? = nil,
      nickname : String? = nil,
      email : String? = nil,
      phone : String? = nil,
      country : String? = nil,
      image : String? = nil,
      ui_theme : String? = nil,
      misc : String? = nil,
      login_name : String? = nil,
      staff_id : String? = nil,
      first_name : String? = nil,
      last_name : String? = nil,
      building : String? = nil,
      card_number : String? = nil,
      groups : Array(String)? = nil,
      sys_admin : Bool? = nil,
      support : Bool? = nil
    ) : User
      post base, body: from_args, as: User
    end

    def update(
      id : String,
      authority_id : String,
      name : String,
      password : String? = nil,
      nickname : String? = nil,
      email : String? = nil,
      phone : String? = nil,
      country : String? = nil,
      image : String? = nil,
      ui_theme : String? = nil,
      misc : String? = nil,
      first_name : String? = nil,
      last_name : String? = nil,
      building : String? = nil,
      # Admin Attributes
      login_name : String? = nil,
      staff_id : String? = nil,
      card_number : String? = nil,
      groups : Array(String)? = nil,
      sys_admin : Bool? = nil,
      support : Bool? = nil
    )
      put "#{base}/#{id}", body: from_args, as: User
    end

    def current
      get "#{base}/current", as: User
    end

    def resource_token
      post "#{base}/resource_token", as: ResourceToken
    end

    # List or search for users.
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
      authority_id : String? = nil
    )
      get base, params: from_args, as: Array(API::Models::User)
    end
  end
end
