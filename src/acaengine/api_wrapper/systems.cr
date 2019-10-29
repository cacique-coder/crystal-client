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
  # `(`  `)` | Provides precedence
  # `~N`     | Specifies edit distance (fuzziness) after a word
  # `~N`     | Specifies slop amount (deviation) after a phrase
  #
  # Up to *limit* systems will be returned, with a paging based on *offset*.
  def systems(q : String? = nil, limit : Int = 20, offset : Int = 0)
    get "/api/control/systems", params: from_args, as: QueryResult(System)
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
    post "/api/control/systems", body: from_args, as: System
  end

  # Retrieves a system based on it's ID.
  def system(id : String)
    get "/api/control/systems/#{id}", as: System
  end

  # Requests a change to an existing system.
  #
  # In addition to specifying the ID of the system to update, you must reference
  # the the current system metadata *version* for the update to be allowed. This
  # must match the current version attribute of the system and will be
  # incrememented following a successful update.
  def update_system(id : String,
                    version : Int,
                    name : String? = nil,
                    zones : Array(String)? = nil,
                    edge_id : String? = nil,
                    description : String? = nil,
                    email : String? = nil,
                    capacity : Int? = nil,
                    bookable : Bool? = nil,
                    installed_ui_devices : Int? = nil,
                    modules : Array(String)? = nil,
                    settings : String? = nil,
                    support_url : String? = nil)
    put "/api/control/systems/#{id}", body: from_args, as: System
  end

  # Deletes a system.
  #
  # This will also stop, and remove any modules that do not belong to other
  # systems.
  def remove_system(id : String)
    delete "/api/control/systems/#{id}"
    nil
  end
end
