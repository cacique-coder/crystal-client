require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Domains do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Domains.new api

    # domains_json = <<-JSON
    # [
    #   {
    #     "name": "Place",
    #     "domain": "engine.place.technology",
    #     "description": "this is a description",
    #     "id": "domain-oOj2lGgsb"
    #   }
    # ]
    # JSON

    # domains = Array(JSON::Any).from_json(domains_json).map &.to_json

    describe "#search" do
    end

    describe "#fetch" do
      # it "inspects a domains metadata" do
      #   WebMock
      #     .stub(:get, DOMAIN + "#{client.base}/domain-oOj2lGgsb")
      #     .to_return(body: domains.first)
      #   result = client.fetch "domain-oOj2lGgsb"
      #   result.should be_a(Client::API::Models::Domain)
      # end
    end

    describe "#destroy" do
    end

    describe "#create" do
    end

    describe "#update" do
    end
  end
end
