require "../../spec_helper"

describe ACAEngine::APIWrapper do
  domain = "http://aca.example.com"

  api = ACAEngine::APIWrapper.new domain

  systems = [] of String
  systems << <<-JSON
    {
      "edge_id": "edge-QC03B3OM",
      "name": "Room 1",
      "description": null,
      "email": "room1@example.com",
      "capacity": 10,
      "features": "",
      "bookable": true,
      "installed_ui_devices": 0,
      "zones": [
        "zone-rGhCRp_aUD"
      ],
      "modules": [
        "mod-rJRCVYKVuB",
        "mod-rJRGK21pya",
        "mod-rJRHYsZExU"
      ],
      "settings": {},
      "created_at": 1562041110,
      "support_url": null,
      "version": 5,
      "id": "sys-rJQQlR4Cn7"
    }
  JSON
  systems << <<-JSON
    {
      "edge_id": "edge-QC03B3OM",
      "name": "Room 2",
      "description": null,
      "email": "room2@example.com",
      "capacity": 10,
      "features": "",
      "bookable": true,
      "installed_ui_devices": 0,
      "zones": [
        "zone-rGhCRp_aUD"
      ],
      "modules": [
        "mod-rJRJOM27Kb",
        "mod-rJRLE4_PQ7",
        "mod-rJRLwe72Mo"
      ],
      "settings": {},
      "created_at": 1562041127,
      "support_url": null,
      "version": 4,
      "id": "sys-rJQSySsELE"
    }
  JSON
  systems << <<-JSON
    {
      "edge_id": "edge-QC03B3OM",
      "name": "Room 3",
      "description": null,
      "email": "room3@example.com",
      "capacity": 4,
      "features": "",
      "bookable": true,
      "installed_ui_devices": 0,
      "zones": [
        "zone-rGhCRp_aUD"
      ],
      "modules": [
        "mod-rJRNrLDPNz",
        "mod-rJRQ~JwE7U",
        "mod-rJRV1qokbH"
      ],
      "settings": {},
      "created_at": 1562041145,
      "support_url": null,
      "version": 4,
      "id": "sys-rJQVPIR9Uf"
    }
  JSON

  describe "#systems" do
    it "enumerates all systems" do
      WebMock
        .stub(:get, "#{domain}/api/control/systems")
        .to_return(body: <<-JSON
          {
            "total": 3,
            "results": [#{systems.join ","}]
          }
          JSON
        )
      result = api.systems
      result.total.should eq(3)
      system = result.results.first
      system.should be_a(ACAEngine::API::Models::System)
      system.name.should eq("Room 1")
    end

    it "provides system search" do
      WebMock
        .stub(:get, "#{domain}/api/control/systems")
        .with(query: {"q" => "\"Room 1\""})
        .to_return(body: <<-JSON
          {
            "total": 1,
            "results": [#{systems.first}]
          }
          JSON
        )
      result = api.systems "\"Room 1\""
      result.total.should eq(1)
      result.results.first.name.should eq("Room 1")
    end

    it "supports paging in system queries" do
      WebMock
        .stub(:get, "#{domain}/api/control/systems")
        .with(query: {"limit" => "1", "offset" => "1"})
        .to_return(body: <<-JSON
          {
            "total": 1,
            "results": [#{systems[1]}]
          }
          JSON
        )
      result = api.systems limit: 1, offset: 1
      result.total.should eq(1)
      result.results.first.name.should eq("Room 2")
    end
  end

  describe "#create_system" do
    it "posts to the systems endpoint" do
      WebMock
        .stub(:post, "#{domain}/api/control/systems")
        .with(
          headers: {"Content-Type" => "application/json"},
          body: {
            name: "Foo",
            zones: ["a", "b", "c"]
          }.to_json
        )
        .to_return(body: systems.first)
      result = api.create_system name: "Foo", zones: ["a", "b", "c"]
      result.should be_a(ACAEngine::API::Models::System)
    end
  end

  describe "#system" do
    it "inspects a systems metadata" do
      WebMock
        .stub(:get, "#{domain}/api/control/systems/sys-rJQQlR4Cn7")
        .to_return(body: systems.first)
      result = api.system "sys-rJQQlR4Cn7"
      result.should be_a(ACAEngine::API::Models::System)
    end
  end

  describe "#update_system" do
    it "send a put request to the systems endpoint" do
      WebMock
        .stub(:put, "#{domain}/api/control/systems/sys-rJQQlR4Cn7")
        .with(
          headers: {"Content-Type" => "application/json"},
          body: { version: 2, name: "Foo" }.to_json
        )
        .to_return(body: systems.first)
      result = api.update_system "sys-rJQQlR4Cn7", version: 2, name: "Foo"
      result.should be_a(ACAEngine::API::Models::System)
    end
  end

  describe "#remove_system" do
    it "execs a delete request" do
      WebMock
        .stub(:delete, "#{domain}/api/control/systems/sys-rJQQlR4Cn7")
      result = api.remove_system "sys-rJQQlR4Cn7"
      result.should be_nil
    end
  end

  describe "#start_system" do
    it "requests a system start" do
      WebMock
        .stub(:post, "#{domain}/api/control/systems/sys-rJQQlR4Cn7/start")
      result = api.start_system "sys-rJQQlR4Cn7"
      result.should be_nil
    end
  end

  describe "#stop_system" do
    it "requests a system stop" do
      WebMock
        .stub(:post, "#{domain}/api/control/systems/sys-rJQQlR4Cn7/stop")
      result = api.stop_system "sys-rJQQlR4Cn7"
      result.should be_nil
    end
  end

  describe "#exec" do
    it "requests a method execution within a system" do
      WebMock
        .stub(:post, "#{domain}/api/control/systems/sys-rJQQlR4Cn7/exec")
        .with(
          headers: {"Content-Type" => "application/json"},
          body: %({"module":"Foo","method":"test","index":2,"args":[]})
        )
        .to_return(body: "[42]")
      result = api.exec "sys-rJQQlR4Cn7", mod: "Foo", index: 2, method: "test"
      result.should eq(42)
    end
  end

  describe "#state" do
    it "requests full module state" do
      WebMock
        .stub(:get, "#{domain}/api/control/systems/sys-rJQQlR4Cn7/state")
        .with(query: {"module" => "Foo", "index" => "2"})
        .to_return(body: %({"a":1,"b":2,"c":3}))
      result = api.state "sys-rJQQlR4Cn7", mod: "Foo", index: 2
      result.should be_a(JSON::Any)
      result["a"].as_i.should eq(1)
    end

    it "requests individual state keys" do
      WebMock
        .stub(:get, "#{domain}/api/control/systems/sys-rJQQlR4Cn7/state")
        .with(query: {"module" => "Foo", "index" => "2", "lookup" => "a"})
        .to_return(body: "1")
      result = api.state "sys-rJQQlR4Cn7", mod: "Foo", index: 2, lookup: "a"
      result.should be_a(JSON::Any)
      result.as_i.should eq(1)
    end
  end

  describe "#funcs" do
    it "requests available behaviours" do
      WebMock
        .stub(:get, "#{domain}/api/control/systems/sys-rJQQlR4Cn7/funcs")
        .with(query: {"module" => "Foo","index" => "2"})
        .to_return(body: <<-JSON
          {
            "function_name": {
              "arity": 3,
              "params": [
                ["req", "foo"],
                ["opt", "bar"],
                ["rest", "baz"]
              ]
            }
          }
        JSON
        )
      result = api.funcs "sys-rJQQlR4Cn7", mod: "Foo", index: 2
      result.should be_a(Hash(String, ACAEngine::API::Models::Function))
    end
  end
end
