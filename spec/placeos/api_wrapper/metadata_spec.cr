require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Metadata do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Metadata.new api

    metadata_json = <<-JSON
    {
      "Place1": {
        "name": "Place1",
        "description": "metadata 1",
        "details": {
          "name": "frodo"
        },
        "parent_id": "zone-oOj2lGgsz"
      },
      "Place2": {
        "name": "Place2",
        "description": "metadata 2",
        "details": {
          "name": "frodo"
        },
        "parent_id": "zone-oOj2lGgsz"
      },
      "Place3": {
        "name": "Place3",
        "description": "metadata 3",
        "details": {
          "name": "frodo"
        },
        "parent_id": "zone-oOj2lGgsz"
      }
    }
    JSON

    mock_metadata = {} of String => String
    Hash(String, JSON::Any).from_json(metadata_json).each { |key, value| mock_metadata[key] = value.to_json }

    describe "#fetch" do
      it "gets metadata for a parent" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/zone-oOj2lGgsz")
          .to_return(status: 200, body: metadata_json)
        client.fetch("zone-oOj2lGgsz").size.should eq 3
      end

      it "filters metadata by name for parent" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/zone-oOj2lGgsz")
          .with(query: {"name" => "Place1"})
          .to_return(status: 200, body: %({"Place1": #{mock_metadata["Place1"]}}))
        client.fetch("zone-oOj2lGgsz", "Place1").size.should eq 1
      end
    end

    pending "#children" do
      # WebMock
      #   .stub(:get, DOMAIN + "#{client.base}/zone-oOj2lGgsz/children")
      #   .to_return(status: 200)
      # result = client.children("zone-oOj2lGgsz")
    end 

    it "#update" do
      WebMock
        .stub(:put, DOMAIN + "#{client.base}/zone-oOj2lGgsz")
        .with(query: {"name" => "Place1"}, body: mock_metadata["Place1"])
        .to_return(status: 200, body: mock_metadata["Place1"])
      client.update("zone-oOj2lGgsz", "Place1", {name: "frodo"}, "metadata 1").should eq Client::API::Models::Metadata.from_json(mock_metadata["Place1"])
    end

    it "#destroy" do
      WebMock
        .stub(:delete, DOMAIN + "#{client.base}/zone-oOj2lGgsz")
        .with(query: {"name" => "Place1"})
        .to_return(status: 200)

      client.destroy("zone-oOj2lGgsz", "Place1").should be_nil
    end
  end
end
