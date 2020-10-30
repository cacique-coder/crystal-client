require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Domains do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Domains.new api

    describe "#search" do
      WebMock
        .stub(:get, DOMAIN + client.base)
        .with(query: {"offset" => "0", "limit" => "20"})
        .to_return(body: %([{"created_at":1603948254,"updated_at":1603948254,"name":"localhost:8443/backoffice","description":"","domain":"localhost","login_url":"/login?continue={{url}}","logout_url":"/auth/logout","internals":{},"config":{},"id":"authority-G03OrvJj~5j"}]))
      result = client.search offset: 0
      result.size.should eq(1)
      domain = result.first
      domain.should be_a(PlaceOS::Client::API::Models::Authority)
      domain.should eq(Array(PlaceOS::Client::API::Models::Authority).from_json(%([{"created_at":1603948254,"updated_at":1603948254,"name":"localhost:8443/backoffice","description":"","domain":"localhost","login_url":"/login?continue={{url}}","logout_url":"/auth/logout","internals":{},"config":{},"id":"authority-G03OrvJj~5j"}]))[0])
    end

    describe "#fetch" do
      WebMock
        .stub(:get, DOMAIN + client.base + "/authority-G03OrvJj~5j")
        # .with(query: {"complete" => "true"})
        .to_return(body: %({"created_at":1603948254,"updated_at":1603948254,"name":"localhost:8443/backoffice","description":"","domain":"localhost","login_url":"/login?continue={{url}}","logout_url":"/auth/logout","internals":{},"config":{},"id":"authority-G03OrvJj~5j"}))
      result = client.fetch id: "authority-G03OrvJj~5j", complete: true
      result.should be_a(PlaceOS::Client::API::Models::Authority)
    end

    describe "#destroy" do
      WebMock
        .stub(:delete, DOMAIN + "#{client.base}/authority-G0S_7R1hW3R")
      result = client.destroy "authority-G0S_7R1hW3R"
      result.should be_nil
    end

    describe "#create" do
      WebMock
        .stub(:post, DOMAIN + client.base)
        .to_return(body: %({"created_at":1604030519,"updated_at":1604030519,"name":"1234","description":"This is a test domain","domain":"localhost","login_url":"localhost:1234/login","logout_url":"localhost:1234/logout","internals":{},"config":{},"id":"authority-G0S_7R1hW3R"}))
      result = client.create name:"1234",updated_at:0,description:"This is a test domain",domain:"localhost",login_url:"localhost:1234/login",logout_url:"localhost:1234/logout", version: 0
      result.should be_a(PlaceOS::Client::API::Models::Authority)
    end

    describe "#update" do
      # Cannot update from BackOffice!

      # WebMock
      # .stub(:put, DOMAIN + client.base + "/authority-G0S_7R1hW3R")
      # .to_return(body: %({"created_at":1604030519,"updated_at":1604030519,"name":"1234","description":"This is a test domain","domain":"localhost","login_url":"localhost:1234/login","logout_url":"localhost:1234/logout","internals":{},"config":{},"id":"authority-G0S_7R1hW3R"}))
      # result = client.create name:"1234",updated_at:0,description:"This is a test domain",domain:"localhost",login_url:"localhost:1234/login",logout_url:"localhost:1234/logout", version: 0
      # result.should be_a(PlaceOS::Client::API::Models::Authority)
    end
  end
end
