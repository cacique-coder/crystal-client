require "../../spec_helper"

describe ACAEngine::APIWrapper do
  api = ACAEngine::APIWrapper.new "http://aca.example.com"

  it "retrieves authority metadata" do
    WebMock.stub(:get, "aca.example.com/api/auth/authority").to_return(body: <<-JSON
      {
        "name": "https://test.aca.im",
        "dom": "test.aca.im",
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
    authority = api.authority
    authority.id.should eq("sgrp-oOO6aZj1-J")
    authority.name.should eq("https://test.aca.im")
    authority.description.should be_nil
    authority.login_url.should eq("/login?continue={{url}}")
    authority.logout_url.should eq("/")
    authority.config["universe"].as_i.should eq(42)
    authority.session.should be_false
    authority.production.should be_true
  end
end
