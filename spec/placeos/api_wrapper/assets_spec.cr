require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Assets do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Assets.new api

    assets_json = <<-JSON
    [
      {
        "name": "Place",
        "description": null,
        "purchase_date": "2016-02-15T10:20:30Z",
        "identifier": "org",
        "purchase_price": 1555995992,
        "id": "asset-oOj2lGgsz",
        "quantity": 0,
        "in_use": 0
      }
    ]
    JSON

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

    assets = Array(JSON::Any).from_json(assets_json).map &.to_json
    instances = Array(JSON::Any).from_json(instances_json).map &.to_json

    describe "search" do
      it "enumerates all assets" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: assets_json)
        result = client.search
        result.size.should eq(1)
        asset = result.first
        asset.should be_a(Client::API::Models::Asset)
        asset.name.should eq("Place")
      end

      it "provides asset search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "Place", "limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: assets_json)
        result = client.search q: "Place"
        result.size.should eq(1)
        result.first.name.should eq("Place")
      end
    end

    describe "#create" do
      it "posts to the assets endpoint" do
        body = {name: "Place", purchase_date: Time.utc(2016, 2, 15, 10, 20, 30)}
        WebMock
          .stub(:post, DOMAIN + client.base)
          .with(
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: body.to_json,
          )
          .to_return(body: assets.first)
        result = client.create(**body)
        result.should be_a(Client::API::Models::Asset)
      end
    end

    describe "#update" do
      it "send a put request to the assets endpoint" do
        WebMock
          .stub(:put, DOMAIN + "#{client.base}/asset-oOj2lGgsz")
          .with(
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: {name: "Foo"}.to_json,
          )
          .to_return(body: assets.first)
        result = client.update(id: "asset-oOj2lGgsz", name: "Foo")
        result.should be_a(Client::API::Models::Asset)
      end
    end

    describe "#delete" do
      it "execs a delete request" do
        WebMock
          .stub(:delete, DOMAIN + "#{client.base}/asset-oOj2lGgsz")
        result = client.destroy "asset-oOj2lGgsz"
        result.should be_nil
      end
    end

    describe "#show" do
      it "gets all asset instances of asset" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/asset-oOj2lGgsz/asset_instances")
          .to_return(body: instances_json)
        result = client.asset_instances("asset-oOj2lGgsz")
        result.size.should eq(1)
        instance = result.first
        instance.should be_a(Client::API::Models::AssetInstance)
        instance.id.should eq("asset_instance-e1k5lEzo")
      end
    end
  end
end
