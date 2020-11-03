require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Authority do
    api = Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Authority.new api

    it "fetches authority metadata" do
      WebMock
        .stub(:get, DOMAIN + client.base)
        .with(headers: HEADERS)
        .to_return(body: <<-JSON
        {
          "id": "sgrp-oOO6aZj1-J",
          "name": "#{DOMAIN}",
          "description": null,
          "domain": "#{URI.parse(DOMAIN).host}",
          "login_url": "/login?continue={{url}}",
          "logout_url": "/",
          "config": {
            "universe": 42
          },
          "version": "2.0"
        }
      JSON
        )

      authority_api = Client::APIWrapper::Authority.new api
      authority = authority_api.fetch
      authority.id.should eq("sgrp-oOO6aZj1-J")
      authority.name.should eq(DOMAIN)
      authority.description.should eq(nil)
      authority.login_url.should eq("/login?continue={{url}}")
      authority.logout_url.should eq("/")
      authority.config["universe"].as_i.should eq(42)
    end
  end
end
