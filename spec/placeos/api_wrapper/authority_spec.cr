require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Authority do
    api = Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Authority.new api

    it "fetches authority metadata" do
      WebMock.stub(:get, client.base).to_return(body: <<-JSON
      {
        "name": "#{DOMAIN}",
        "dom": "#{URI.parse(DOMAIN).host}",
        "description": null,
        "login_url": "/login?continue={{url}}",
        "logout_url": "/",
        "config": {
          "universe": 42
        },
        "id": "sgrp-oOO6aZj1-J",
        "session": false,
        "production": true
      }
    JSON
      )

      authority_api = Client::APIWrapper::Authority.new api
      authority = authority_api.fetch
      authority.id.should eq("sgrp-oOO6aZj1-J")
      authority.name.should eq("https://test.place.tech")
      authority.description.should be_nil
      authority.login_url.should eq("/login?continue={{url}}")
      authority.logout_url.should eq("/")
      authority.config["universe"].as_i.should eq(42)
      authority.session.should be_false
      authority.production.should be_true
    end
  end
end
