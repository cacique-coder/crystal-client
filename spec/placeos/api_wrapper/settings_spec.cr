require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Settings do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Settings.new api

    settings_json = <<-JSON
    [
      {
        "id": "settings-oOj2lGgsz",
        "parent_id": "Place",
        "encryption_level": "None",
        "parent_type": "Driver"
      }
    ]
    JSON

    settings = Array(JSON::Any).from_json(settings_json).map &.to_json

    describe "#search" do
      it "enumerates all settings" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: settings_json)
        result = client.search
        result.size.should eq(1)
        result.first.should be_a(PlaceOS::Model::Settings)
        result.first.parent_id.should eq("Place")
      end

      it "provides settings search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "Place", "limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: settings_json)
        result = client.search q: "Place"
        result.size.should eq(1)
        result.first.parent_id.should eq("Place")
      end
    end

    it "#fetch" do
      WebMock
        .stub(:get, DOMAIN + "#{client.base}/settings-oOj2lGgsz")
        .to_return(body: settings.first)
      result = client.fetch "settings-oOj2lGgsz"
      result.should be_a(PlaceOS::Model::Settings)
      result.to_json.should contain("\"parent_id\":\"Place\",\"encryption_level\":0,\"settings_string\":\"{}\",\"keys\":[],\"parent_type\":1}")
    end

    it "#destroy" do
      WebMock
        .stub(:delete, DOMAIN + "#{client.base}/settings-oOj2lGgsz")
      result = client.destroy "settings-oOj2lGgsz"
      result.should be_nil
    end

    it "#create" do
      body = {parent_id: "Foo", encryption_level: "None", parent_type: "Driver", settings_string: "settings", settings_id: "unique id", keys: ["key1", "key2"]}.to_json
      WebMock
        .stub(:post, DOMAIN + client.base)
        .with(
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: body
        )
        .to_return(body: settings.first)
      result = client.create(parent_id: "Foo", encryption_level: "None", parent_type: "Driver", settings_string: "settings", settings_id: "unique id", keys: ["key1", "key2"])
      result.should be_a(PlaceOS::Model::Settings)
      result.to_json.should contain("\"parent_id\":\"Place\",\"encryption_level\":0,\"settings_string\":\"{}\",\"keys\":[],\"parent_type\":1}")
    end

    it "#update" do
      WebMock
        .stub(:put, DOMAIN + "#{client.base}/settings-oOj2lGgsz")
        .with(
          headers: {"Content-Type" => "application/json"},
          body: {parent_id: "Foo"}.to_json
        )
        .to_return(body: settings.first)
      result = client.update "settings-oOj2lGgsz", parent_id: "Foo", encryption_level: nil, parent_type: nil, settings_string: nil, settings_id: nil, keys: nil
      result.should be_a(PlaceOS::Model::Settings)
      result.to_json.should contain("\"parent_id\":\"Place\",\"encryption_level\":0,\"settings_string\":\"{}\",\"keys\":[],\"parent_type\":1}")
    end

    describe "#history" do
    end
  end
end
