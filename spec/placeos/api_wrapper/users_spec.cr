require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Users do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Users.new api

    users_json = <<-JSON
    [
      {
        "id": "user-oOj2lGgsz",
        "name": "Place",
        "description": null,
        "tags": ["org"],
        "triggers": [],
        "created_at": 1555995992,
        "updated_at": 1555996000,
        "count": 0,
        "capacity": 2
      }
    ]
    JSON

    users = Array(JSON::Any).from_json(users_json).map &.to_json

    describe "#search" do
      it "enumerates all users" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: users_json)
        result = client.search
        result.size.should eq(1)
        result.first.should be_a(PlaceOS::Model::User)
        result.first.name.should eq("Place")
      end

      it "provides user search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "Place", "limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: users_json)
        result = client.search q: "Place"
        result.size.should eq(1)
        result.first.name.should eq("Place")
      end
    end

    it "#fetch" do
      WebMock
        .stub(:get, DOMAIN + "#{client.base}/user-oOj2lGgsz")
        .to_return(body: users.first)
      result = client.fetch "user-oOj2lGgsz"
      result.should be_a(PlaceOS::Model::User)
    end

    it "#destroy" do
      WebMock
        .stub(:delete, DOMAIN + "#{client.base}/user-oOj2lGgsz")
      result = client.destroy "user-oOj2lGgsz"
      result.should be_nil
    end

    describe "#create" do
      it "should create a user with minimum attributes" do
        body = {authority_id: "hello", name: "Place"}.to_json
        WebMock
          .stub(:post, DOMAIN + client.base)
          .with(
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: body,
          )
          .to_return(body: users.first)
        result = client.create authority_id: "hello", name: "Place"
        result.should be_a(PlaceOS::Model::User)
      end

      it "should create a user with all the attributes" do
        body = {authority_id: "hello", name: "Place", nickname: "place nickname"}.to_json
        WebMock
          .stub(:post, DOMAIN + client.base)
          .with(
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: body,
          )
          .to_return(body: users.first)
        result = client.create authority_id: "hello", name: "Place", nickname: "place nickname"
        result.should be_a(PlaceOS::Model::User)
      end
    end

    describe "#update" do
      res = "{\"created_at\":1603948255,\"name\":\"Place Support (localhost=>8443)\",\"nickname\":\"\",\"email\":\"support@place.tech\",\"phone\":\"\",\"country\":\"\",\"image\":\"\",\"ui_theme\":\"light\",\"misc\":\"\",\"deleted\":false,\"groups\":[],\"expires\":false,\"sys_admin\":true,\"support\":false}"
      WebMock
        .stub(:put, DOMAIN + client.base + "/user-G03JG1kx3yS")
        .to_return(body: res)
      result = client.update id: "user-G03JG1kx3yS", version: 0, name: "Place Support (localhost:8443)", updated_at:1604021794, password:"development", authority_id:"authority-G03OrvJj~5j", email:"support@place.tech", email_digest: "18270840d5b8357a2175208b63ca52a4", staff_id:"21341234", support:true, sys_admin:true, ui_theme:"light"
      result.should be_a(PlaceOS::Model::User)
    end

    describe "#current" do
      user_parsed = {"id" => "user-G03JG1kx3yS", "email_digest" => "18270840d5b8357a2175208b63ca52a4", "nickname" => "", "name" => "Place Support (localhost=>8443)", "first_name" => nil, "last_name" => nil, "country" => "", "building" => nil, "image" => "", "created_at" => 1603948255, "sys_admin" => true, "support" => false, "email" => "support@place.tech", "phone" => "", "ui_theme" => "light", "metadata" => "", "login_name" => nil, "staff_id" => nil, "card_number" => nil, "groups" => [] of String}
      WebMock
        .stub(:get, DOMAIN + client.base + "/current")
        .to_return(body: user_parsed.to_json)
      result = client.current
      result.should be_a(PlaceOS::Model::User)
    end

    describe "#resource_token" do
      # WebMock
      #   .stub(:post, DOMAIN + client.base + "/resource_token")
      #   .to_return(body: "")
      # result = client.resource_token
      # result.should be_a(ResourceToken)
      # result.to_json.should eq("")
    end
  end
end
