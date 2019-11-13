require "../../spec_helper"

describe ACAEngine::APIWrapper do
  domain = "http://aca.example.com"

  api = ACAEngine::APIWrapper.new domain

  modules = [] of String
  modules << <<-JSON
    {
      "dependency_id": "dep-wJHShR4Ffa",
      "control_module_id": null,
      "edge_id": "edge-E9vIruSZ",
      "ip": "10.45.6.3",
      "tls": false,
      "udp": false,
      "port": 8192,
      "makebreak": false,
      "uri": null,
      "custom_name": null,
      "settings": {},
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
  JSON

  describe "#search_modules" do
    it "enumerates all modules" do
      WebMock
        .stub(:get, "#{domain}/api/control/modules")
        .to_return(body: <<-JSON
          {
            "total": #{modules.size},
            "results": [#{modules.join ","}]
          }
          JSON
        )
      result = api.search_modules
      result.total.should eq(1)
      mod = result.results.first
      mod.should be_a(ACAEngine::API::Models::Module)
      mod.ip.should eq("10.45.6.3")
    end

    it "provides module search" do
      WebMock
        .stub(:get, "#{domain}/api/control/modules")
        .with(query: {"q" => "\"Not there\""})
        .to_return(body: <<-JSON
          {
            "total": 0,
            "results": []
          }
          JSON
        )
      result = api.search_modules "\"Not there\""
      result.total.should eq(0)
    end
  end

  describe "#create_module" do
    it "posts to the modules endpoint" do
      WebMock
        .stub(:post, "#{domain}/api/control/modules")
        .with(
          headers: {"Content-Type" => "application/json"},
          body: {
            dependency_id: "abc-123",
            edge_id: "def-456"
          }.to_json
        )
        .to_return(body: modules.first)
      result = api.create_module dependency_id: "abc-123", edge_id: "def-456"
      result.should be_a(ACAEngine::API::Models::Module)
    end
  end

  describe "#retrieve_module" do
    it "inspects module metadata" do
      WebMock
        .stub(:get, "#{domain}/api/control/modules/mod-wJHYeHm6Yn")
        .to_return(body: modules.first)
      result = api.retrieve_module "mod-wJHYeHm6Yn"
      result.should be_a(ACAEngine::API::Models::Module)
    end
  end

  describe "#update_module" do
    it "send a put request to the modules endpoint" do
      WebMock
        .stub(:put, "#{domain}/api/control/modules/mod-wJHYeHm6Yn")
        .with(
          headers: {"Content-Type" => "application/json"},
          body: { ignore_connected: true }.to_json
        )
        .to_return(body: modules.first)
      result = api.update_module "mod-wJHYeHm6Yn", ignore_connected: true
      result.should be_a(ACAEngine::API::Models::Module)
    end
  end

  describe "#delete_module" do
    it "sends a delete request" do
      WebMock
        .stub(:delete, "#{domain}/api/control/modules/mod-wJHYeHm6Yn")
      result = api.delete_module "mod-wJHYeHm6Yn"
      result.should be_nil
    end
  end

  describe "#start_module" do
    it "requests a module start" do
      WebMock
        .stub(:post, "#{domain}/api/control/modules/mod-wJHYeHm6Yn/start")
      result = api.start_module "mod-wJHYeHm6Yn"
      result.should be_nil
    end
  end

  describe "#stop_module" do
    it "requests a module stop" do
      WebMock
        .stub(:post, "#{domain}/api/control/modules/mod-wJHYeHm6Yn/stop")
      result = api.stop_module "mod-wJHYeHm6Yn"
      result.should be_nil
    end
  end

  describe "#state" do
    it "requests full module state" do
      WebMock
        .stub(:get, "#{domain}/api/control/modules/mod-wJHYeHm6Yn/state")
        .to_return(body: %({"a":1,"b":2,"c":3}))
      result = api.state "mod-wJHYeHm6Yn"
      result.should be_a(JSON::Any)
      result["a"].as_i.should eq(1)
    end

    it "requests individual state keys" do
      WebMock
        .stub(:get, "#{domain}/api/control/modules/mod-wJHYeHm6Yn/state")
        .with(query: {"lookup" => "a"})
        .to_return(body: "1")
      result = api.state "mod-wJHYeHm6Yn", lookup: "a"
      result.should be_a(JSON::Any)
      result.as_i.should eq(1)
    end
  end
end
