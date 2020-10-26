require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Triggers < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Trigger)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/triggers"

    # CRUD Actions
    def search(
      authority_id : String?,
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0
    )
      get base, params: from_args, as: Array(Trigger)
    end

    def create(
      control_system_id : String,
      name : String,
      description : String?,
      actions : String?,
      conditions : String?,
      debounce_period : Int32?,
      important : Bool?,
      enable_webhook : Bool?,
      supported_methods : Array(String)?
    )
      post base, body: from_args, as: Trigger
    end

    def update(
      id : String,
      control_system_id : String,
      name : String,
      description : String?,
      actions : String?,
      conditions : String?,
      debounce_period : Int32?,
      important : Bool?,
      enable_webhook : Bool?,
      supported_methods : Array(String)?
    )
      put "#{base}/#{id}", body: from_args, as: Trigger
    end

    # Unique Actions
    def instances(id : String)
      get "#{base}/#{id}/instance", as: Array(Trigger)
    end
  end
end
