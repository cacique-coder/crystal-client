require "../api/models/module"
require "../api/models/ping"

require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Modules < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Module)
    include Client::APIWrapper::Endpoint::Destroy
    include Client::APIWrapper::Endpoint::StartStop
    include Client::APIWrapper::Endpoint::Settings
    # Results my also also be limited to those associated with a specific
    # *system_id*, that are instances of a *driver_id*, or any combination of
    # these.
    include Client::APIWrapper::Endpoint::Search(Module)

    getter base : String = "#{API_ROOT}/modules"

    # Interaction
    ###########################################################################

    # Performs a connectivity check with the associated device or service.
    def ping(id : String)
      post "#{base}/#{id}/ping", as: API::Models::Ping
    end

    # Queries the state exposed by a module.
    def state(id : String, lookup : String? = nil)
      path = "#{base}/#{id}/state"
      path += "/#{lookup}" if lookup

      get path
    end

    # Management
    ###########################################################################

    # Creates a new module.
    def create(
      driver_id : String,
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
      ignore_startstop : Bool? = nil
    )
      post base, body: from_args, as: Module
    end

    # Updates module attributes or configuration.
    def update(
      id : String,
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
      ignore_startstop : Bool? = nil
    )
      put "#{base}/#{id}", body: from_args, as: Module
    end

    # Unique Actions
    def execute(
      id : String,
      method : String,
      *args : Array(JSON::Any::Type)
    )
      post "#{base}/#{id}/exec/#{method}", body: args
    end

    def load(id : String)
      post "#{base}/#{id}/load"
    end
  end
end
