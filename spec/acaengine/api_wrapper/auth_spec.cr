require "../../spec_helper"

describe ACAEngine::APIWrapper do
  api = ACAEngine::APIWrapper.new "http://aca.example.com"

  it "retries authority metadata" do
    WebMock.stub(:get, "aca.example.com/api/auth/authority").to_return(body: <<-JSON
      {
        "name": "https://test.aca.im",
        "dom": "test.aca.im",
        "description": null,
        "login_url": "/login?continue={{url}}",
        "logout_url": "/",
        "config": {},
        "id": "sgrp-oOO6aZj1-J",
        "session": false,
        "production": true
      }
    JSON
    )
    authority = api.authority
    authority.id.should eq("sgrp-oOO6aZj1-J")
  end
end
