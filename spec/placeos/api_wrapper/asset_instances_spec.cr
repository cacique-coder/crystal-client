require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::AssetInstances do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::AssetInstances.new api

    instances_json = <<-JSON
    [
      {
        "name": "Place",
        "approval": false,
        "usage_start": "2016-02-15T10:20:30Z",
        "usage_end": "2016-02-15T10:21:30Z",
        "asset_id": "asset-oOj2lGgsz",
        "id":  "asset_instance-e1k5lEzo"
      }
    ]
    JSON

    instances = Array(JSON::Any).from_json(instances_json).map &.to_json

    describe "search" do
      it "enumerates all asset instances" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: instances_json)
        result = client.search
        result.size.should eq(1)
        asset = result.first
        asset.should be_a(Client::API::Models::AssetInstance)
        asset.name.should eq("Place")
      end

      it "provides asset instance search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "Place", "limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: instances_json)
        result = client.search q: "Place"
        result.size.should eq(1)
        result.first.name.should eq("Place")
      end
    end

    describe "#create" do
      it "posts to the asset instances endpoint" do
        body = {name: "Place", usage_start: Time.utc(2016, 2, 15, 10, 20, 30), usage_end: Time.utc(2016, 2, 15, 10, 21, 30)}

        WebMock
          .stub(:post, DOMAIN + client.base)
          .with(
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: body.to_json,
          )
          .to_return(body: instances.first)
        result = client.create(**body)
        result.should be_a(Client::API::Models::AssetInstance)
      end
    end

    describe "#update" do
      it "send a put request to the asset instances endpoint" do
        WebMock
          .stub(:put, DOMAIN + "#{client.base}/asset_instance-e1k5lEzo")
          .with(
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: {name: "Foo"}.to_json,
          )
          .to_return(body: instances.first)
        result = client.update(id: "asset_instance-e1k5lEzo", name: "Foo")
        result.should be_a(Client::API::Models::AssetInstance)
      end
    end

    describe "#delete" do
      it "execs a delete request" do
        WebMock
          .stub(:delete, DOMAIN + "#{client.base}/asset_instance-e1k5lEzo")
        result = client.destroy "asset_instance-e1k5lEzo"
        result.should be_nil
      end
    end
  end
end
