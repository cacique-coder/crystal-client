require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Settings do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Settings.new api

    # settings_json = <<-JSON
    # [
    #   {
    #     "id": "setting-oOj2lGgsz",
    #     "parent_id": ""
    #     "name": "Place",
    #     "description": null,
    #     "tags": ["org"],
    #     "triggers": [],
    #     "created_at": 1555995992,
    #     "updated_at": 1555996000,
    #     "count": 0,
    #     "capacity": 2
    #   }
    # ]
    # JSON

    # settings = Array(JSON::Any).from_json(settings_json).map &.to_json

    describe "#search" do
      # it "enumerates all settings" do
      #   WebMock
      #     .stub(:get, DOMAIN + client.base)
      #     .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
      #     .to_return(body: settings_json)
      #   result = client.search
      #   result.size.should eq(1)
      #   result.first.should be_a(Client::API::Models::Setting)
      #   result.first.name.should eq("Place")
      # end

      # it "provides setting search" do
      #   WebMock
      #     .stub(:get, DOMAIN + client.base)
      #     .with(query: {"q" => "Place", "limit" => "20", "offset" => "0"}, headers: HEADERS)
      #     .to_return(body: drivers_json)
      #   result = client.search q: "Place"
      #   result.size.should eq(2)
      #   result.first.name.should eq("Place")
      # end
    end

    describe "#fetch" do
    end

    it "#destroy" do
      WebMock
        .stub(:delete, DOMAIN + "#{client.base}/setting-oOj2lGgsz")
      result = client.destroy "setting-oOj2lGgsz"
      result.should be_nil
    end

    describe "#create" do
    end

    describe "#update" do
    end

    describe "#history" do
    end
  end
end
