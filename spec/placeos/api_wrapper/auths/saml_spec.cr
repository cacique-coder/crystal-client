require "../../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Saml do
    api = Client::APIWrapper.new DOMAIN
    Client::APIWrapper::Saml.new api
  end
end
