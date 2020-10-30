require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Triggers do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Triggers.new api

    triggers_json = <<-JSON
    [
      {
        "name": "Place",
        "authority_id": "hello",
        "description": null,
        "tags": ["org"],
        "triggers": [],
        "created_at": 1555995992,
        "updated_at": 1555996000,
        "id": "trigger-oOj2lGgsz",
        "count": 0,
        "capacity": 2
      }
    ]
    JSON

    triggers = Array(JSON::Any).from_json(triggers_json).map &.to_json

    describe "#search" do
      it "enumerates all triggers" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"authority_id" => "hello", "limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: triggers_json)
        result = client.search "hello"
        result.size.should eq(1)
        result.first.should be_a(PlaceOS::Model::Trigger)
        result.first.name.should eq("Place")
      end

      it "provides trigger search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"authority_id" => "hello", "limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: triggers_json)
        result = client.search "hello"
        result.size.should eq(1)
        result.first.name.should eq("Place")
      end
    end

    it "#fetch" do
      WebMock
        .stub(:get, DOMAIN + "#{client.base}/trigger-oOj2lGgsz")
        .to_return(body: triggers.first)
      result = client.fetch "trigger-oOj2lGgsz"
      result.should be_a(PlaceOS::Model::Trigger)
      result.to_json.should eq("{\"created_at\":1555995992,\"updated_at\":1555996000,\"name\":\"Place\",\"description\":\"\",\"actions\":{\"functions\":[],\"mailers\":[]},\"conditions\":{\"comparisons\":[],\"time_dependents\":[]},\"debounce_period\":0,\"important\":false,\"enable_webhook\":false,\"supported_methods\":[\"POST\"]}")
    end

    it "#destroy" do
      WebMock
        .stub(:delete, DOMAIN + "#{client.base}/trigger-oOj2lGgsz")
      result = client.destroy "trigger-oOj2lGgsz"
      result.should be_nil
    end

    it "#create" do
      body = {control_system_id: "hello", name: "Place"}.to_json
      WebMock
        .stub(:post, DOMAIN + client.base)
        .with(
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: body
        )
        .to_return(body: triggers.first)
      result = client.create(control_system_id: "hello", name: "Place")
      result.should be_a(PlaceOS::Model::Trigger)
      result.to_json.should eq("{\"created_at\":1555995992,\"updated_at\":1555996000,\"name\":\"Place\",\"description\":\"\",\"actions\":{\"functions\":[],\"mailers\":[]},\"conditions\":{\"comparisons\":[],\"time_dependents\":[]},\"debounce_period\":0,\"important\":false,\"enable_webhook\":false,\"supported_methods\":[\"POST\"]}")
    end

    it "#update" do
      WebMock
        .stub(:put, DOMAIN + "#{client.base}/trigger-oOj2lGgsz")
        .with(
          headers: {"Content-Type" => "application/json"},
          body: {control_system_id: "foo", name: "Foo"}.to_json
        )
        .to_return(body: triggers.first)
      result = client.update "trigger-oOj2lGgsz", control_system_id: "foo", name: "Foo"
      result.should be_a(PlaceOS::Model::Trigger)
      result.to_json.should eq("{\"created_at\":1555995992,\"updated_at\":1555996000,\"name\":\"Place\",\"description\":\"\",\"actions\":{\"functions\":[],\"mailers\":[]},\"conditions\":{\"comparisons\":[],\"time_dependents\":[]},\"debounce_period\":0,\"important\":false,\"enable_webhook\":false,\"supported_methods\":[\"POST\"]}")
    end

    describe "#instances" do
    end
  end
end
