require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Modules do
    api = Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Modules.new api

    modules_json = <<-JSON
    [
      {
        "driver_id": "driver-wJHShR4Ffa",
        "control_system_id": null,
        "ip": "10.45.6.3",
        "tls": false,
        "udp": false,
        "port": 8192,
        "makebreak": false,
        "uri": null,
        "custom_name": null,
        "name": "Switcher",
        "updated_at": 1572412023,
        "created_at": 1572412023,
        "role": 1,
        "connected": true,
        "running": true,
        "notes": null,
        "ignore_connected": false,
        "ignore_startstop": false,
        "id": "mod-wJHYeHm6Yn"
      }
    ]
    JSON

    modules = Array(JSON::Any).from_json(modules_json).map &.to_json

    describe "#search" do
      it "enumerates all modules" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: modules_json)
        result = client.search
        result.size.should eq(1)
        mod = result.first
        mod.should be_a(PlaceOS::Model::Module)
        mod.ip.should eq("10.45.6.3")
      end

      it "provides module search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "\"Not there\"", "limit" => "20", "offset" => "0"})
          .to_return(body: "[]")
        result = client.search "\"Not there\""
        result.size.should eq(0)
      end
    end

    describe "#create" do
      it "posts to the modules endpoint" do
        WebMock
          .stub(:post, DOMAIN + client.base)
          .with(
            headers: {"Content-Type" => "application/json"},
            body: {
              driver_id: "abc-123",
            }.to_json
          )
          .to_return(body: modules.first)
        result = client.create driver_id: "abc-123"
        result.should be_a(PlaceOS::Model::Module)
      end
    end

    describe "#fetch" do
      it "inspects module metadata" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/mod-wJHYeHm6Yn")
          .to_return(body: modules.first)
        result = client.fetch "mod-wJHYeHm6Yn"
        result.should be_a(PlaceOS::Model::Module)
      end
    end

    describe "#update" do
      it "send a put request to the modules endpoint" do
        WebMock
          .stub(:put, DOMAIN + "#{client.base}/mod-wJHYeHm6Yn")
          .with(
            headers: {"Content-Type" => "application/json"},
            body: {ignore_connected: true}.to_json
          )
          .to_return(body: modules.first)
        result = client.update "mod-wJHYeHm6Yn", ignore_connected: true
        result.should be_a(PlaceOS::Model::Module)
      end
    end

    describe "#delete" do
      it "sends a delete request" do
        WebMock
          .stub(:delete, DOMAIN + "#{client.base}/mod-wJHYeHm6Yn")
        result = client.destroy "mod-wJHYeHm6Yn"
        result.should be_nil
      end
    end

    describe "#start" do
      it "requests a module start" do
        WebMock
          .stub(:post, DOMAIN + "#{client.base}/mod-wJHYeHm6Yn/start")
        result = client.start "mod-wJHYeHm6Yn"
        result.should be_nil
      end
    end

    describe "#stop" do
      it "requests a module stop" do
        WebMock
          .stub(:post, DOMAIN + "#{client.base}/mod-wJHYeHm6Yn/stop")
        result = client.stop "mod-wJHYeHm6Yn"
        result.should be_nil
      end
    end

    describe "#state" do
      it "requests full module state" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/mod-wJHYeHm6Yn/state")
          .to_return(body: %({"a":1,"b":2,"c":3}))
        result = client.state "mod-wJHYeHm6Yn"
        result.should be_a(JSON::Any)
        result["a"].as_i.should eq(1)
      end

      it "requests individual state keys" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/mod-wJHYeHm6Yn/state/a")
          .to_return(body: "1")
        result = client.state "mod-wJHYeHm6Yn", "a"
        result.should be_a(JSON::Any)
        result.as_i.should eq(1)
      end
    end

    describe "#ping" do
    end

    describe "#settings" do
    end

    describe "#execute" do
    end

    describe "#load" do
    end
  end
end
