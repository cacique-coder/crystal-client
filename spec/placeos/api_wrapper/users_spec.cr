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
        "authority_id": "hello",
        "created_at": 1555995992,
        "updated_at": 1555996000,
        "email_digest": "",
        "nickname": "",
        "first_name": "",
        "last_name": "",
        "country": "",
        "building": "",
        "image": ""
        
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
        result.first.should be_a(PlaceOS::Client::API::Models::User)
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
      result.should be_a(PlaceOS::Client::API::Models::User)
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
        result.should be_a(PlaceOS::Client::API::Models::User)
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
        result.should be_a(PlaceOS::Client::API::Models::User)
      end
    end

    it "#update" do
      res = {"id" => "user-G03JG1kx3yS", "email_digest" => "18270840d5b8357a2175208b63ca52a4", "nickname" => "", "name" => "Place Support (localhost=>8443)", "created_at" => 155599599, "updated_at" => 1555996000, "first_name" => "hello", "last_name" => "", "country"=> "", "building" => "", "image"=> ""}.to_json
      WebMock
        .stub(:put, DOMAIN + client.base + "/user-G03JG1kx3yS")
        .to_return(body: res)
      result = client.update "user-G03JG1kx3yS", authority_id:"authority-G03OrvJj~5j", name: "hello"
      result.should be_a(PlaceOS::Client::API::Models::User)
    end

    it "#current" do
      user_parsed = {"id" => "user-G03JG1kx3yS", "email_digest" => "18270840d5b8357a2175208b63ca52a4", "nickname" => "", "name" => "Place Support (localhost=>8443)", "created_at" => 1555995992, "updated_at" => 1555996000, "first_name" => "hello", "last_name" => "", "country"=> "", "building" => "", "image"=> ""}
      WebMock
        .stub(:get, DOMAIN + client.base + "/current")
        .to_return(body: user_parsed.to_json)
      result = client.current
      result.should be_a(PlaceOS::Client::API::Models::User)
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
