require "../response"

module PlaceOS::Client::API::Models
  struct OAuthAuthentication < Response
    include Timestamps

    getter id : String
    getter name : String
    getter authority_id : String

    # The client ID and secret configured for this application
    getter client_id : String
    getter client_secret : String

    # Maps an expected key to a provided key i.e. {used_in_engine => used_by_remote}
    getter info_mappings : Hash(String, String)

    # The HTTP URL of the SSO provider
    getter site : String

    # The SSO providers URL for authorization, defaults to: `oauth/authorize`
    # Google is `/o/oauth2/auth`
    getter authorize_url : String

    # If not set it defaults to "post"
    getter token_method : String

    # If not set it defaults to "request_body", others include "basic_auth"
    getter auth_scheme : String

    # defaults to: `oauth/token` however google is: `/o/oauth2/token`
    getter token_url : String

    # Space seperated scope strings
    # i.e. `https://www.googleapis.com/auth/devstorage.readonly https://www.googleapis.com/auth/prediction`
    getter scope : String

    # URL to call with a valid token to obtain the users profile data (name, email etc)
    getter raw_info_url : String
  end
end
