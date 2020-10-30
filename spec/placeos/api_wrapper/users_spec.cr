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

      # [:created_at, :updated_at, :authority_id, :name, :nickname, :email, :phone, :country, :image, :ui_theme, :misc, :login_name, :staff_id, :first_name, :last_name, :building, :password_digest, :email_digest, :card_number, :deleted, :groups, :access_token, :refresh_token, :expires_at, :expires, :password, :sys_admin, :support, :id]
      PlaceOS::Model::User.attributes.each { |attribute| 
        puts attribute
        
      }

      # puts PlaceOS::Model::User.nickname
    
  
    end

    describe "#update" do
    end

    describe "#current" do
    end

    describe "#resource_token" do
    end
  end
end
