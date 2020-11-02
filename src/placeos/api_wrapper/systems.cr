require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Systems < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(PlaceOS::Model::ControlSystem)
    include Client::APIWrapper::Endpoint::Destroy
    include Client::APIWrapper::Endpoint::StartStop
    include Client::APIWrapper::Endpoint::Settings

    getter base : String = "#{API_ROOT}/systems"

    # Interaction
    ###########################################################################

    # Executes a behaviour exposed by a module within the passed system *id*.
    def execute(
      id : String,
      module_name : String,
      method : String,
      index : Int32 = 1,
      *args : Array(JSON::Any::Type)
    )
      post "#{base}/#{id}/#{module_name}_#{index}/#{method}", body: args
    end

    # Queries the state exposed by a module within the passed system *id*.
    def state(id : String, module_name : String, index : Int = 1, lookup : String? = nil)
      path = "#{base}/#{id}/#{module_name}_#{index}"
      path += "/#{lookup}" unless lookup.nil?
      get path
    end

    # Queries the behaviour exposed by a module within system *id*.
    def functions(id : String, module_name : String, index : Int = 1)
      get "#{base}/#{id}/functions/#{module_name}_#{index}", as: Hash(String, Function)
    end

    # Gets the number of *module_name* instances available in system *id*.
    def count(id : String, module_name : String) : Int32?
      types(id)[module_name]?
    end

    # Queries the types of modules available in system *id*.
    def types(id : String)
      get "#{base}/#{id}/types", as: Hash(String, Int32)
    end

    # Management
    ###########################################################################

    # Creates a new system.
    #
    # Systems must be given a unique *name* within the PlaceOS instance they are
    # running from. Additionally, a system must be a member of at least one
    # *zone*. All other attributes are optional at the time of creation.
    def create(
      name : String,
      zones : Array(String),
      description : String? = nil,
      email : String? = nil,
      capacity : Int? = nil,
      bookable : Bool? = nil,
      installed_ui_devices : Int? = nil,
      modules : Array(String)? = nil,
      support_url : String? = nil
    )
      post base, body: from_args, as: PlaceOS::Model::ControlSystem
    end

    # Requests a change to an existing system.
    #
    # In addition to specifying the ID of the system to update, you must reference
    # the the current system metadata *version* for the update to be allowed. This
    # must match the current version attribute of the system and will be
    # incrememented following a successful update.
    def update(
      id : String,
      version : Int,
      name : String? = nil,
      zones : Array(String)? = nil,
      description : String? = nil,
      email : String? = nil,
      capacity : Int? = nil,
      bookable : Bool? = nil,
      installed_ui_devices : Int? = nil,
      modules : Array(String)? = nil,
      support_url : String? = nil
    )
      put "#{base}/#{id}", params: "version=#{version}", body: from_args, as: PlaceOS::Model::ControlSystem
    end

    # Search
    ###########################################################################

    # List or search for systems.
    #
    # Results maybe filtered by specifying a query - *q* - to search across system
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
    def search(
      q : String? = nil,
      limit : Int = 1000,
      offset : Int = 0,
      zone_id : String? = nil,
      module_id : String? = nil,
      features : String? = nil,
      capacity : Int32? = nil,
      bookable : Bool? = nil
    )
      get base, params: from_args, as: Array(PlaceOS::Model::ControlSystem)
    end

    # Returns systems with a specified email address(es)
    #
    def with_emails(in : Array(String) | String)
      query = in.is_a?(Array) ? in.join(',') : in

      get "#{base}/with_emails", params: HTTP::Params{"in" => query}, as: Array(PlaceOS::Model::ControlSystem)
    end

    # Unique Actions
    def zones(id : String)
      get "#{base}/#{id}/zones"
    end

    def add_module(id : String, module_id : String)
      put "#{base}/#{id}/module/#{module_id}", as: PlaceOS::Model::Module
    end

    def remove_module(id : String, module_id : String)
      delete "#{base}/#{id}/module/#{module_id}", as: PlaceOS::Model::Module
    end

    def control
      ws "#{base}/control"
    end

    private getter client

    def initialize(@client : APIWrapper)
    end
  end
end
