require "../../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::OAuth do
    api = Client::APIWrapper.new DOMAIN
    Client::APIWrapper::OAuth.new api
  end
end
