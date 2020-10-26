require "./endpoint"

module PlaceOS
  # TODO:
  # - search (index)
  # - create
  # - update
  class Client::APIWrapper::Users < Client::APIWrapper::Endpoint
    include Client::APIWrapper::Endpoint::Fetch(User)
    include Client::APIWrapper::Endpoint::Destroy

    getter base : String = "#{API_ROOT}/users"

    # CRUD Actions
    def search(
      q : String? = nil,
      limit : Int = 20,
      offset : Int = 0
    )
      get base, params: from_args, as: Array(User)
    end

    def create(
      authority_id : String,
      name : String,
      nickname : String?,
      email : String?,
      phone : String?,
      country : String?,
      image : String?,
      ui_theme : String?,
      metadata : String?,
      login_name : String?,
      staff_id : String?,
      first_name : String?,
      last_name : String?,
      building : String?,
      password_digest : String?,
      email_digest : String?,
      card_number : String?,
      deleted : Bool?,
      groups : Array(String)?,
      access_token : String?,
      refresh_token : String?,
      expires_at : Int64?,
      expires : Bool?,
      password : String?,
      sys_admin : Bool?,
      support : Bool?
    )
      post base, body: from_args, as: User
    end

    def update(
      id : String,
      authority_id : String,
      name : String,
      nickname : String?,
      email : String?,
      phone : String?,
      country : String?,
      image : String?,
      ui_theme : String?,
      metadata : String?,
      login_name : String?,
      staff_id : String?,
      first_name : String?,
      last_name : String?,
      building : String?,
      password_digest : String?,
      email_digest : String?,
      card_number : String?,
      deleted : Bool?,
      groups : Array(String)?,
      access_token : String?,
      refresh_token : String?,
      expires_at : Int64?,
      expires : Bool?,
      password : String?,
      sys_admin : Bool?,
      support : Bool?
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
