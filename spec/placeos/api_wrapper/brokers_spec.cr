require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Repositories do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Brokers.new api

    brokers_json = ([] of String).to_json

    # brokers = Array(JSON::Any).from_json(brokers_json).map &.to_json

    describe "#index" do
      WebMock
        .stub(:get, DOMAIN + client.base)
        .to_return(body: brokers_json)
      result = client.index
      result.size.should eq(0)
      # br = result.first
      # br.should be_a(PlaceOS::Model::Broker)
      # br.attribute.should be_a(attribute_value)
    end

    # describe "#create" do
    #   it "posts to the brokers endpoint" do
    #     WebMock
    #       .stub(:post, DOMAIN + client.base)
    #       .with(
    #         headers: {"Content-Type" => "application/json"},
    #         body: {
    #           driver_id: "abc-123",
    #         }.to_json
    #       )
    #       .to_return(body: brokers.first)
    #     result = client.create driver_id: "abc-123"
    #     result.should be_a(PlaceOS::Model::Broker)
    #   end
    # end

    # describe "#fetch" do
    #   it "inspects broker metadata" do
    #     broker_id = ""
    #     WebMock
    #       .stub(:get, DOMAIN + "#{client.base}/#{broker_id}")
    #       .to_return(body: brokers.first)
    #     result = client.fetch broker_id
    #     result.should be_a(PlaceOS::Model::Broker)
    #   end
    # end

    # describe "#update" do
    #   it "send a put request to the brokers endpoint" do
    #     broker_id = ""
    #     WebMock
    #       .stub(:put, DOMAIN + "#{client.base}/#{broker_id}")
    #       .with(
    #         headers: {"Content-Type" => "application/json"},
    #         body: {ignore_connected: true}.to_json
    #       )
    #       .to_return(body: brokers.first)
    #     result = client.update broker_id, ignore_connected: true
    #     result.should be_a(PlaceOS::Model::Broker)
    #   end
    # end

    # describe "#delete" do
    #   it "sends a delete request" do
    #     broker_id = ""
    #     WebMock
    #       .stub(:delete, DOMAIN + "#{client.base}/#{broker_id}")
    #     result = client.destroy broker_id
    #     result.should be_nil
    #   end
    # end
  end
end
