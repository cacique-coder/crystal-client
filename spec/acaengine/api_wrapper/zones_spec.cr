require "../../spec_helper"

describe PlaceOS::APIWrapper do
  domain = "http://aca.example.com"

  api = PlaceOS::APIWrapper.new domain

  zones = [] of String
  zones << <<-JSON
    {
      "name": "ACA",
      "description": null,
      "tags": "org",
      "settings": {},
      "triggers": [],
      "created_at": 1555995992,
      "id": "zone-oOj2lGgszq"
    }
  JSON

  describe "#search_zones" do
    it "enumerates all zones" do
      WebMock
        .stub(:get, "#{domain}/api/control/zones")
        .to_return(body: <<-JSON
          {
            "total": #{zones.size},
            "results": [#{zones.join ","}]
          }
          JSON
        )
      result = api.search_zones
      result.total.should eq(1)
      zone = result.results.first
      zone.should be_a(PlaceOS::API::Models::Zone)
      zone.name.should eq("ACA")
    end

    it "provides zone search" do
      WebMock
        .stub(:get, "#{domain}/api/control/zones")
        .with(query: {"q" => "ACA"})
        .to_return(body: <<-JSON
          {
            "total": 1,
            "results": [#{zones.first}]
          }
          JSON
        )
      result = api.search_zones "ACA"
      result.total.should eq(1)
      result.results.first.name.should eq("ACA")
    end
  end

  describe "#create_zone" do
    it "posts to the zones endpoint" do
      WebMock
        .stub(:post, "#{domain}/api/control/zones")
        .with(
          headers: {"Content-Type" => "application/json"},
          body: {name: "ACA"}.to_json
        )
        .to_return(body: zones.first)
      result = api.create_zone name: "ACA"
      result.should be_a(PlaceOS::API::Models::Zone)
    end
  end

  describe "#retrieve_zone" do
    it "inspects a zones metadata" do
      WebMock
        .stub(:get, "#{domain}/api/control/zones/zone-oOj2lGgsz")
        .to_return(body: zones.first)
      result = api.retrieve_zone "zone-oOj2lGgsz"
      result.should be_a(PlaceOS::API::Models::Zone)
    end
  end

  describe "#update_zone" do
    it "send a put request to the zones endpoint" do
      WebMock
        .stub(:put, "#{domain}/api/control/zones/zone-oOj2lGgsz")
        .with(
          headers: {"Content-Type" => "application/json"},
          body: {name: "Foo"}.to_json
        )
        .to_return(body: zones.first)
      result = api.update_zone "zone-oOj2lGgsz", name: "Foo"
      result.should be_a(PlaceOS::API::Models::Zone)
    end
  end

  describe "#delete_zone" do
    it "execs a delete request" do
      WebMock
        .stub(:delete, "#{domain}/api/control/zones/zone-oOj2lGgsz")
      result = api.delete_zone "zone-oOj2lGgsz"
      result.should be_nil
    end
  end
end
