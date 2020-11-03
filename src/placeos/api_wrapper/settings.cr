require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Settings < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(PlaceOS::Client::API::Models::Settings)
    include Client::APIWrapper::Endpoint::Destroy
    include Client::APIWrapper::Endpoint::Search(PlaceOS::Client::API::Models::Settings)

    getter base : String = "#{API_ROOT}/settings"

    # CRUD Actions
    # def search(
    #   parent_id : String?,
    #   q : String? = nil,
    #   limit : Int = 20,
    #   offset : Int = 0
    # )
    #   get base, params: from_args, as: Array(API::Models::Settings)
    # end

    def create(
      parent_id : String,
      encryption_level : String,
      parent_type : String,
      settings_string : String = "{}",
      settings_id : String? = nil,
      keys : Array(String) = [] of String
    )
      post base, body: from_args, as: PlaceOS::Client::API::Models::Settings
    end

    def update(
      id : String,
      parent_id : String,
      encryption_level : String?,
      parent_type : String?,
      settings_string : String?,
      settings_id : String?,
      keys : Array(String)?
    )
      put "#{base}/#{id}", body: from_args, as: PlaceOS::Client::API::Models::Settings
    end

    # Unique Actions
    def history(id : String, offset : Int32?, limit : Int32?)
      get "#{base}/#{id}/history", params: from_args
    end
  end
end
