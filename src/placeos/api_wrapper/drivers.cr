require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Drivers < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Search(Driver)
    include Client::APIWrapper::Endpoint::Fetch(Driver)
    # include Client::APIWrapper::Endpoint::Create(Driver)
    # include Client::APIWrapper::Endpoint::Update(Driver)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/drivers"

    def create(
      name : String,
      role : String,
      commit : String,
      file_name : String,
      module_name : String,
      repository_id : String,
      default_uri : String? = nil,
      default_port : Int32? = nil,
      description : String? = nil,
      ignore_connected : Bool? = nil
    )
      post base, body: from_args, as: Driver
    end

    def update(
      id : String,
      name : String? = nil,
      role : String? = nil,
      commit : String? = nil,
      file_name : String? = nil,
      module_name : String? = nil,
      default_uri : String? = nil,
      default_port : Int32? = nil,
      description : String? = nil,
      ignore_connected : Bool? = nil
    )
      put "#{base}/#{id}", body: from_args, as: Driver
    end

    # Unique Actions
    def recompile(id : String)
      post "#{base}/#{id}/recompile", as: Driver
    end

    def compiled(id : String)
      get "#{base}/#{id}/compiled", as: Driver
    end
  end
end
