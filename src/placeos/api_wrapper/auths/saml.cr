require "./base"

module PlaceOS
  # :nodoc:
  alias SamlAuthentication = PlaceOS::Model::SamlAuthentication

  class Client::APIWrapper::Saml < Client::APIWrapper::AuthBase(SamlAuthentication)
    getter base : String = "#{API_ROOT}/saml_auths"

    def create(
      name : String,
      authority_id : String,
      issuer : String,
      idp_sso_target_url : String,
      name_identifier_format : String,
      assertion_consumer_service_url : String,
      request_attributes : Array(NamedTuple(name: String, name_format: String, friendly_name: String)),
      idp_sso_target_url_runtime_params : Hash(String, String)? = nil,
      uid_getter : String? = nil,
      idp_cert : String? = nil,
      idp_cert_fingerprint : String? = nil,
      getter_service_name : String? = nil,
      getter_statements : Hash(String, Array(String))? = nil,
      idp_slo_target_url : String? = nil,
      slo_default_relay_state : String? = nil
    )
      super(**args)
    end

    def update(
      id : String,
      name : String? = nil,
      authority_id : String? = nil,
      issuer : String? = nil,
      idp_sso_target_url : String? = nil,
      name_identifier_format : String? = nil,
      assertion_consumer_service_url : String? = nil,
      request_attributes : Array(NamedTuple(name: String, name_format: String, friendly_name: String))? = nil,
      idp_sso_target_url_runtime_params : Hash(String, String)? = nil,
      uid_getter : String? = nil,
      idp_cert : String? = nil,
      idp_cert_fingerprint : String? = nil,
      getter_service_name : String? = nil,
      getter_statements : Hash(String, Array(String))? = nil,
      idp_slo_target_url : String? = nil,
      slo_default_relay_state : String? = nil
    )
      super(**args)
    end
  end
end
