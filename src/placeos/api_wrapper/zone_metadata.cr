require "./endpoint"

module PlaceOS
  class Client::APIWrapper::ZoneMetadata < Client::APIWrapper::Endpoint
    getter base : String = "#{API_ROOT}/zones"

    def fetch(id : String, name : String? = nil)
      get "#{base}/#{id}/metadata", params: from_args, as: API::Models::Zone::Metadata
    end

    def children(id : String, name : String? = nil)
      get "#{base}/#{id}/metadata/children", params: from_args, as: Array(NamedTuple(
        zone: API::Models::Zone,
        metadata: Hash(String, API::Models::Zone::Metadata)))
    end

    def update(
      id : String,
      name : String,
      details : JSON::Any | Hash | NamedTuple,
      description : String? = nil
    )
      body = {name: name, description: description, details: details, zone_id: id}
      post "#{base}/#{id}/metadata", body: body, as: API::Models::Zone::Metadata
    end

    def destroy(id : String, name : String)
      delete "#{base}/#{id}/metadata"
      nil
    end
  end
end
