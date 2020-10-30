require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Root do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Root.new api

    describe "#signal" do
    end

    describe "#version" do
      # WebMock
      #   .stub(:get, DOMAIN + client.base + "/version")
      #   .to_return(body: %({"app":"rest-api","version":"1.17.5","commit":"9c9e8430871f90ec0f198d1bd932487f009acb59","build_time":"Thu Aug 27 22:36:57 UTC 2020\n"}))
      # result = client.version
      # result.should be_a(PlaceOS::Client::API::Models::Version)
    end

    describe "#root" do
    end

    describe "#reindex" do
      WebMock
        .stub(:get, DOMAIN + client.base + "/reindex")
        .with(query: {"backfill" => "true"})
      result = client.reindex
      result.should eq(nil)
    end

    describe "#backfill" do
      WebMock
        .stub(:get, DOMAIN + client.base + "/backfill")
      result = client.backfill
      result.should eq(nil)
    end
  end
end
