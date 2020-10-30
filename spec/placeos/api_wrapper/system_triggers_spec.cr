require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::SystemTriggers do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::SystemTriggers.new api

    system_triggers_json = <<-JSON
    [
      {
        "control_system_id": "Place",
        "webhook_secret": "shh it's a secret"
      }
    ]
    JSON

    system_triggers = Array(JSON::Any).from_json(system_triggers_json).map &.to_json

    describe "#search" do
      it "enumerates all system triggers" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: system_triggers_json)
        result = client.search
        result.size.should eq(1)
        result.first.should be_a(PlaceOS::Model::TriggerInstance)
        result.first.control_system_id.should eq("Place")
      end

      it "provides system trigger search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "Place", "limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: system_triggers_json)
        result = client.search q: "Place"
        result.size.should eq(1)
        result.first.control_system_id.should eq("Place")
      end
    end

    it "#fetch" do
      WebMock
        .stub(:get, DOMAIN + "#{client.base}/systems-trigger-oOj2lGgsz")
        .to_return(body: system_triggers.first)
      result = client.fetch "systems-trigger-oOj2lGgsz", complete: nil
      result.should be_a(PlaceOS::Model::TriggerInstance)
      result.to_json.should contain("\"control_system_id\":\"Place\",\"enabled\":true,\"triggered\":false,\"important\":false,\"exec_enabled\":false,\"webhook_secret\":\"shh it's a secret\",\"trigger_count\":0}")
    end

    it "#destroy" do
      WebMock
        .stub(:delete, DOMAIN + "#{client.base}/systems-trigger-oOj2lGgsz")
      result = client.destroy "systems-trigger-oOj2lGgsz"
      result.should be_nil
    end

    describe "#create" do
    end

    describe "#update" do
    end
  end
end
