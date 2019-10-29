require "../../spec_helper"

describe ACAEngine::APIWrapper do
  api = ACAEngine::APIWrapper.new "http://aca.example.com"

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
        .stub(:get, "aca.example.com/api/control/systems")
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
        .stub(:get, "aca.example.com/api/control/systems")
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
        .stub(:get, "aca.example.com/api/control/systems")
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
        .stub(:post, "aca.example.com/api/control/systems")
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
        .stub(:get, "aca.example.com/api/control/systems/sys-rJQQlR4Cn7")
        .to_return(body: systems.first)
      result = api.system "sys-rJQQlR4Cn7"
      result.should be_a(ACAEngine::API::Models::System)
    end
  end

  describe "#update_system" do
    it "send a put request to the systems endpoint" do
      WebMock
        .stub(:put, "aca.example.com/api/control/systems/sys-rJQQlR4Cn7")
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
        .stub(:delete, "aca.example.com/api/control/systems/sys-rJQQlR4Cn7")
      result = api.remove_system "sys-rJQQlR4Cn7"
      result.should be_nil
    end
  end
end
