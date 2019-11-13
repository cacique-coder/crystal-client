class ACAEngine::APIWrapper
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

  # Retrieves all metadata associated with a system.
  def retrieve_system(id : String)
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

  # Removes a system.
  #
  # This will also stop, and remove any modules that do not belong to other
  # systems.
  def delete_system(id : String)
    delete "/api/control/systems/#{id}"
    nil
  end
end
