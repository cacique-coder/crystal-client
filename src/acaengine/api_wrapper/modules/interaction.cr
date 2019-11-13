class ACAEngine::APIWrapper
  # Starts a module.
  def start_module(id : String)
    post "/api/control/modules/#{id}/start"
    nil
  end

  # Stops a module.
  def stop_module(id : String)
    post "/api/control/modules/#{id}/stop"
    nil
  end

  # Performs a connectivity check with the associated device or service.
  def ping(id : String)
    post "/api/control/modules/#{id}/ping", as: Ping
  end

  # Queries the state exposed by a module.
  def state(id : String,
            lookup : String? = nil)
    get "/api/control/modules/#{id}/state", params: from_args
  end
end
