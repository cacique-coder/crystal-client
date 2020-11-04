require "./endpoint"

module PlaceOS
  class Client::APIWrapper::Users < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Search(User)
    include Client::APIWrapper::Endpoint::Fetch(User)
    # include Client::APIWrapper::Endpoint::Create(User)
    # include Client::APIWrapper::Endpoint::Update(User)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/users"

    def create(
      authority_id : String,
      name : String,
      nickname : String? = "",
      email : String? = "",
      phone : String? = "",
      country : String? = "",
      image : String? = "",
      ui_theme : String? = "light",
      metadata : String? = "",
      login_name : String? = "",
      staff_id : String? = "",
      first_name : String? = "",
      last_name : String? = "",
      building : String? = "",
      password_digest : String? = "",
      email_digest : String? = "",
      card_number : String? = "",
      deleted : Bool? = false,
      groups : Array(String)? = [] of String,
      access_token : String? = "",
      refresh_token : String? = "",
      expires_at : Int64? = nil,
      expires : Bool? = false,
      password : String? = "",
      sys_admin : Bool? = false,
      support : Bool? = false
    ) : User
      post base, body: from_args, as: User
    end

    def update(
      id : String,
      authority_id : String,
      name : String,
      nickname : String? = "",
      email : String? = "",
      phone : String? = "",
      country : String? = "",
      image : String? = "",
      ui_theme : String? = "light",
      metadata : String? = "",
      login_name : String? = "",
      staff_id : String? = "",
      first_name : String? = "",
      last_name : String? = "",
      building : String? = "",
      password_digest : String? = "",
      email_digest : String? = "",
      card_number : String? = "",
      deleted : Bool? = false,
      groups : Array(String)? = [] of String,
      access_token : String? = "",
      refresh_token : String? = "",
      expires_at : Int64? = nil,
      expires : Bool? = false,
      password : String? = "",
      sys_admin : Bool? = false,
      support : Bool? = false
    )
      put "#{base}/#{id}", body: from_args, as: User
    end

    def current
      get "#{base}/current", as: User
    end

    def resource_token
      post "#{base}/resource_token", as: ResourceToken
    end
  end
end
