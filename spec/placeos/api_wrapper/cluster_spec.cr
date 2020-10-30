require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Cluster do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Cluster.new api

    describe "#search" do
      # WebMock
      #   .stub(:get, DOMAIN + client.base)
      #   .with(query: {include_status: "true"})
      #   .to_return(body: %())
      # result = client.version
      # result.should be_a(PlaceOS::Client::API::Models::Cluster)
    end

    describe "#fetch" do
    end

    describe "#destroy" do
    end
  end
end
