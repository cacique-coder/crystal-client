require "./endpoint"

module PlaceOS
  class Client::APIWrapper::SystemTriggers < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Destroy
    include Client::APIWrapper::Endpoint::Search(TriggerInstance)
    include Client::APIWrapper::Endpoint::Update(TriggerInstance)

    # SystemTriggers are embedded beneath a systems route
    getter base : String = "#{API_ROOT}/systems"

    # CRUD Actions
    # def search(
    #   control_system_id : String?,
    #   trigger_id : String?,
    #   zone_id : String?,
    #   q : String? = nil,
    #   limit : Int = 20,
    #   offset : Int = 0
    # )
    #   get base, params: from_args, as: Array(API::Models::TriggerInstance)
    # end

    def fetch(id : String, complete : Bool?)
      get "#{base}/#{id}", params: from_args, as: TriggerInstance
    end

    def create(
      control_system_id : String,
      trigger_id : String,
      zone_id : String,
      enabled : Bool?,
      triggered : Bool?,
      important : Bool?,
      exec_enabled : Bool?,
      webhook_secret : String?,
      trigger_count : Int32?
    )
      post base, body: from_args, as: TriggerInstance
    end

    # def update(
    #   id : String,
    #   control_system_id : String?,
    #   trigger_id : String?,
    #   zone_id : String?,
    #   enabled : Bool?,
    #   triggered : Bool?,
    #   important : Bool?,
    #   exec_enabled : Bool?,
    #   webhook_secret : String?,
    #   trigger_count : Int32?
    # )
    #   post "#{base}/#{id}", body: from_args, as: PlaceOS::Model::TriggerInstance
    # end
  end
end
