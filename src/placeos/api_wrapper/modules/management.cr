class PlaceOS::APIWrapper
  # Creates a new module.
  def create_module(dependency_id : String,
                    edge_id : String,
                    control_system_id : String? = nil,
                    ip : String? = nil,
                    udp : Bool? = nil,
                    port : Int? = nil,
                    makebreak : Bool? = nil,
                    uri : String? = nil,
                    custom_name : String? = nil,
                    settings : Settings? = nil,
                    notes : String? = nil,
                    ignore_connected : Bool? = nil,
                    ignore_startstop : Bool? = nil)
    post "/api/control/modules", body: from_args, as: Module
  end

  # Retrieves all metadata associated with a module.
  def retrieve_module(id : String)
    get "/api/control/modules/#{id}", as: Module
  end

  # Updates module attributes or configuration.
  def update_module(id : String,
                    edge_id : String? = nil,
                    control_system_id : String? = nil,
                    ip : String? = nil,
                    udp : Bool? = nil,
                    port : Int? = nil,
                    makebreak : Bool? = nil,
                    uri : String? = nil,
                    custom_name : String? = nil,
                    settings : Settings? = nil,
                    notes : String? = nil,
                    ignore_connected : Bool? = nil,
                    ignore_startstop : Bool? = nil)
    put "/api/control/modules/#{id}", body: from_args, as: Module
  end

  # Removes a module.
  def delete_module(id : String)
    delete "/api/control/modules/#{id}"
    nil
  end
end
