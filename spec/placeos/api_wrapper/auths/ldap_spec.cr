require "../../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Ldap do
    api = Client::APIWrapper.new DOMAIN
    Client::APIWrapper::Ldap.new api
  end
end
