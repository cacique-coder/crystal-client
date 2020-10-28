require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Cluster do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Cluster.new api

    # cluster_json = <<-JSON
    # [
    #   {
    #     "id": "cluster-oOj2lGgsa"
    #   }
    # ]
    # JSON

    # cluster = Array(JSON::Any).from_json(cluster_json).map &.to_json

    describe "#search" do
      # it "enumerates all clusters" do
      #   WebMock
      #     .stub(:get, DOMAIN + client.base)
      #     .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
      #     .to_return(body: cluster_json)
      #   result = client.search
      #   result.size.should eq(1)
      #   result.first.should be_a(Client::API::Models::Cluster)
      #   # cluster.first.name.should eq("Place")
      # end
    end

    describe "#fetch" do
    end

    describe "#destroy" do
    end
  end
end
