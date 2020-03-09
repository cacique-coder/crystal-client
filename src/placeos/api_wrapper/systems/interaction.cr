class PlaceOS::APIWrapper
  # Start all modules within a system.
  def start_system(id : String)
    post "/api/control/systems/#{id}/start"
    nil
  end

  # Stops all modules within a system.
  def stop_system(id : String)
    post "/api/control/systems/#{id}/stop"
    nil
  end

  # Executes a behaviour exposed by a module within the passed system *id*.
  def exec(id : String,
           mod : String,
           method : String,
           index : Int = 1,
           *args : Array(JSON::Any::Type))
    response = post "/api/control/systems/#{id}/exec", body: from_args
    # Responses are always wrapped in an outer array
    response[0]?
  end

  # Queries the state exposed by a module within the passed system *id*.
  def state(id : String,
            mod : String,
            index : Int = 1,
            lookup : String? = nil)
    get "/api/control/systems/#{id}/state", params: from_args
  end

  # Queries the behaviour exposed by a module within system *id*.
  def funcs(id : String,
            mod : String,
            index : Int = 1)
    get "/api/control/systems/#{id}/funcs", params: from_args, as: Hash(String, Function)
  end

  # Gets the number of *mod* instances available in system *id*.
  def count(id : String,
            mod : String)
    response = get "/api/control/systems/#{id}/count", params: from_args
    response["count"].as_i
  end

  # Queries the types of modules available in system *id*.
  def types(id : String)
    get "/api/control/systems/#{id}/types", as: Hash(String, Int32)
  end
end
