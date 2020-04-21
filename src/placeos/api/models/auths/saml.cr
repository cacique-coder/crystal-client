require "../response"

module PlaceOS::Client::API::Models
  struct SamlAuthentication < Response
    include Timestamps

    getter id : String
    getter name : String
    getter authority_id : String

    # The name of your application
    getter issuer : String

    # mapping of request params that exist during the request phase of OmniAuth that should to be sent to the IdP
    getter idp_sso_target_url_runtime_params : Hash(String, String)

    # Describes the format of the username required by this application
    getter name_identifier_format : String

    # getter that uniquely identifies the user
    # (If unset, the name identifier returned by the IdP is used.)
    getter uid_getter : String

    # The URL at which the SAML assertion should be received (SSO Service => Engine URL)
    getter assertion_consumer_service_url : String

    # The URL to which the authentication request should be sent (Engine => SSO Service)
    getter idp_sso_target_url : String

    # The identity provider's certificate in PEM format (this or fingerprint is required)
    getter idp_cert : String

    # The SHA1 fingerprint of the certificate
    getter idp_cert_fingerprint : String

    # Name for the getter service (Defaults to Required getters)
    getter getter_service_name : String

    # Used to map getter Names in a SAMLResponse to entries in the OmniAuth info hash
    getter getter_statements : Hash(String, Array(String))

    # Used to map getter Names in a SAMLResponse to entries in the OmniAuth info hash
    getter request_getters : Array(NamedTuple(name: String, name_format: String, friendly_name: String))

    # The URL to which the single logout request and response should be sent
    getter idp_slo_target_url : String

    # The value to use as default RelayState for single log outs
    getter slo_default_relay_state : String
  end
end
