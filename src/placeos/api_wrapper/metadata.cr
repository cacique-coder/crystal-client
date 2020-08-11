require "../api/models/metadata"
require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Metadata < Client::APIWrapper::Endpoint
    getter base : String = "#{API_ROOT}/metadata"

    def fetch(id : String, name : String? = nil)
      get "#{base}/#{id}", params: from_args, as: Hash(String, API::Models::Metadata)
    end

    def children(id : String, name : String? = nil)
      get "#{base}/#{id}/children", params: from_args, as: Array(NamedTuple(zone: API::Models::Zone, metadata: Hash(String, API::Models::Metadata)))
    end

    def update(
      id : String,
      name : String,
      details : JSON::Any | Hash | NamedTuple | Array,
      description : String? = nil
    )
      params = HTTP::Params{"name" => name}
      body = {name: name, description: description, details: details, parent_id: id}
      put "#{base}/#{id}?#{params}", body: body, as: API::Models::Metadata
    end

    def destroy(id : String, name : String)
      delete "#{base}/#{id}", params: from_args
      nil
    end
  end
end
