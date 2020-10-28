require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::OAuthApplications do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::OAuthApplications.new api

    oauth_applications_json = <<-JSON
    [
      {
        "id": "oauthapplication-oOj2lGgsz",  
        "name": "Place",
        "authority_id": "authority_id",
        "uid": "client_id",
        "secret": "client_secret",
        "scopes": "scropes",
        "owner_id": "owner_id",
        "redirect_uri": "redirect_uri",
        "skip_authorization": true,
        "confidential": true,
        "revoked_at": 1555996000,
        "created_at": 1555995992,
        "updated_at": 1555996000
      }
    ]
    JSON

    oauth_applications = Array(JSON::Any).from_json(oauth_applications_json).map &.to_json

    describe "#search" do
      it "enumerates all oauth applications" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: oauth_applications_json)
        result = client.search
        result.size.should eq(1)
        result.first.should be_a(Client::API::Models::OAuthApplication)
        result.first.name.should eq("Place")
      end

      it "provides oauth application search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "Place", "limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: oauth_applications_json)
        result = client.search q: "Place"
        result.size.should eq(1)
        result.first.name.should eq("Place")
      end
    end

    it "#fetch" do
      WebMock
        .stub(:get, DOMAIN + "#{client.base}/oauthapplication-oOj2lGgsz")
        .to_return(body: oauth_applications.first)
      result = client.fetch "oauthapplication-oOj2lGgsz"
      result.should be_a(Client::API::Models::OAuthApplication)
      result.to_json.should eq("{\"created_at\":1555995992,\"updated_at\":1555996000,\"id\":\"oauthapplication-oOj2lGgsz\",\"name\":\"Place\",\"authority_id\":\"authority_id\",\"uid\":\"client_id\",\"secret\":\"client_secret\",\"scopes\":\"scropes\",\"owner_id\":\"owner_id\",\"redirect_uri\":\"redirect_uri\",\"skip_authorization\":true,\"confidential\":true,\"revoked_at\":1555996000}")
    end

    it "#destroy" do
      WebMock
        .stub(:delete, DOMAIN + "#{client.base}/oauthapplication-oOj2lGgsz")
      result = client.destroy "oauthapplication-oOj2lGgsz"
      result.should be_nil
    end

    it "#create" do
      body = {name: "Place", uid: "client_id", secret: "client_secret", scopes: "scropes", owner_id: "owner_id", redirect_uri: "redirect_uri", skip_authorization: true, confidential: true}.to_json
      WebMock
        .stub(:post, DOMAIN + client.base)
        .with(
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: body
        )
        .to_return(body: oauth_applications.first)
      result = client.create(name: "Place", uid: "client_id", secret: "client_secret", scopes: "scropes", owner_id: "owner_id", redirect_uri: "redirect_uri", skip_authorization: true, confidential: true)
      result.should be_a(Client::API::Models::OAuthApplication)
      result.to_json.should eq("{\"created_at\":1555995992,\"updated_at\":1555996000,\"id\":\"oauthapplication-oOj2lGgsz\",\"name\":\"Place\",\"authority_id\":\"authority_id\",\"uid\":\"client_id\",\"secret\":\"client_secret\",\"scopes\":\"scropes\",\"owner_id\":\"owner_id\",\"redirect_uri\":\"redirect_uri\",\"skip_authorization\":true,\"confidential\":true,\"revoked_at\":1555996000}")
    end

    it "#update" do
      WebMock
        .stub(:put, DOMAIN + "#{client.base}/oauthapplication-oOj2lGgsz")
        .with(
          headers: {"Content-Type" => "application/json"},
          body: {name: "Foo"}.to_json
        )
        .to_return(body: oauth_applications.first)
      result = client.update "oauthapplication-oOj2lGgsz", name: "Foo"
      result.should be_a(Client::API::Models::OAuthApplication)
      result.to_json.should eq("{\"created_at\":1555995992,\"updated_at\":1555996000,\"id\":\"oauthapplication-oOj2lGgsz\",\"name\":\"Place\",\"authority_id\":\"authority_id\",\"uid\":\"client_id\",\"secret\":\"client_secret\",\"scopes\":\"scropes\",\"owner_id\":\"owner_id\",\"redirect_uri\":\"redirect_uri\",\"skip_authorization\":true,\"confidential\":true,\"revoked_at\":1555996000}")
    end
  end
end
