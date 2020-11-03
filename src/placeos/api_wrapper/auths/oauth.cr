require "./base"

module PlaceOS
  # :nodoc:
  alias OAuthAuthentication = Client::API::Models::OAuthAuthentication

  class Client::APIWrapper::OAuth < Client::APIWrapper::AuthBase(OAuthAuthentication)
    getter base : String = "#{API_ROOT}/oauth_auths"

    def create(
      name : String,
      authority_id : String,
      client_id : String? = nil,
      client_secret : String? = nil,
      info_mappings : Hash(String, String)? = nil,
      site : String? = nil,
      authorize_url : String? = nil,
      token_method : String? = nil,
      auth_scheme : String? = nil,
      token_url : String? = nil,
      scope : String? = nil,
      raw_info_url : String? = nil
    )
      super(**args)
    end

    def update(
      id : String,
      name : String? = nil,
      authority_id : String? = nil,
      client_id : String? = nil,
      client_secret : String? = nil,
      info_mappings : Hash(String, String)? = nil,
      site : String? = nil,
      authorize_url : String? = nil,
      token_method : String? = nil,
      auth_scheme : String? = nil,
      token_url : String? = nil,
      scope : String? = nil,
      raw_info_url : String? = nil
    )
      super(**args)
    end
  end
end
