require "../api/models/module"
require "../api/models/ping"

require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Modules < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(Module)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/modules"

    # Interaction
    ###########################################################################

    # Starts a module.
    def start(id : String)
      post "#{base}/#{id}/start"
      nil
    end

    # Stops a module.
    def stop(id : String)
      post "#{base}/#{id}/stop"
      nil
    end

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

    # Search
    ###########################################################################

    # List or search for modules.
    #
    # Results maybe filtered by specifying a query - *q* - to search across module
    # attributes. A small query language is supported within this:
    #
    # Operator | Action
    # -------- | ------
    # `+`      | Matches both terms
    # `|`      | Matches either terms
    # `-`      | Negates a single token
    # `"`      | Wraps tokens to form a phrase
    # `(`  `)` | Provides precedence
    # `~N`     | Specifies edit distance (fuzziness) after a word
    # `~N`     | Specifies slop amount (deviation) after a phrase
    #
    # Up to *limit* systems will be returned, with a paging based on *offset*.
    #
    # Results my also also be limited to those associated with a specific
    # *system_id*, that are instances of a *driver_id*, or any combination of
    # these.
    def search(
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0,
      control_system_id : String? = nil,
      driver_id : String? = nil
    )
      get base, params: from_args, as: Array(API::Models::Module)
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
      post base, body: from_args, as: API::Models::Module
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
      put "#{base}/#{id}", body: from_args, as: API::Models::Module
    end
  end
end
