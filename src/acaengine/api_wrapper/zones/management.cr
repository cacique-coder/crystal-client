class ACAEngine::APIWrapper
  # Creates a new zone.
  def create_zone(name : String,
                  description : String? = nil,
                  tags : String? = nil,
                  settings : ::JSON::Any? = nil,
                  triggers : Array(String)? = nil)
    post "/api/control/zones", body: from_args, as: Zone
  end

  # Retrieves all metadata associated with a zone.
  def retrieve_zone(id : String)
    get "/api/control/zones/#{id}", as: Zone
  end

  # Updates zone attributes or configuration.
  def update_zone(id : String,
                  name : String? = nil,
                  description : String? = nil,
                  tags : String? = nil,
                  settings : ::JSON::Any? = nil,
                  triggers : Array(String)? = nil)
    put "/api/control/zones/#{id}", body: from_args, as: Zone
  end

  # Removes a zone.
  def delete_zone(id : String)
    delete "/api/control/zones/#{id}"
    nil
  end
end
