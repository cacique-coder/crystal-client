require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Users < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(PlaceOS::Model::User)
    include Client::APIWrapper::Endpoint::Destroy
    include Client::APIWrapper::Endpoint::Search(PlaceOS::Model::User)

    getter base : String = "#{API_ROOT}/users"

    def create(
      authority_id : String,
      name : String,
      nickname : String? = "",
      **args

      # email : String? = "",
      # phone : String? = "",
      # country : String? = "",
      # image : String? = "",
      # ui_theme : String? = "light",
      # metadata : String? = "",
      # login_name : String?,
      # staff_id : String?,
      # first_name : String?,
      # last_name : String?,
      # building : String?,
      # password_digest : String?,
      # email_digest : String?,
      # card_number : String?,
      # deleted : Bool? = false,
      # groups : Array(String)?,
      # access_token : String?,
      # refresh_token : String?,
      # expires_at : Int64?,
      # expires : Bool?,
      # password : String?,
      # sys_admin : Bool?,
      # support : Bool?
    ) : PlaceOS::Model::User
      post base, body: from_args, as: PlaceOS::Model::User
    end

    def update(
      id : String,
      **args
      # authority_id : String,
      # name : String,
      # nickname : String?,
      # email : String?,
      # phone : String?,
      # country : String?,
      # image : String?,
      # ui_theme : String?,
      # metadata : String?,
      # login_name : String?,
      # staff_id : String?,
      # first_name : String?,
      # last_name : String?,
      # building : String?,
      # password_digest : String?,
      # email_digest : String?,
      # card_number : String?,
      # deleted : Bool?,
      # groups : Array(String)?,
      # access_token : String?,
      # refresh_token : String?,
      # expires_at : Int64?,
      # expires : Bool?,
      # password : String?,
      # sys_admin : Bool?,
      # support : Bool?
    )
      put "#{base}/#{id}", body: from_args, as: PlaceOS::Model::User
    end

    def current
      get "#{base}/current", as: PlaceOS::Model::User
    end

    def resource_token
      post "#{base}/resource_token", as: ResourceToken
    end
  end
end
