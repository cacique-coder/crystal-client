require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Edges do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Edges.new api

    edges_json = <<-JSON
    [
      {
        "id":"edge123",
        "name":"Place",
        "description":"",
        "secret":"s3cr3t",
        "created_at":1555995992,
        "updated_at":1555996000
      }
    ]
    JSON

    edges = Array(JSON::Any).from_json(edges_json).map &.to_json

    describe "search" do
      it "enumerates all edges" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: edges_json)
        result = client.search
        result.size.should eq(1)
        zone = result.first
        zone.should be_a(Client::API::Models::Edge)
        zone.name.should eq("Place")
      end

      it "provides zone search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "Place", "limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: edges_json)
        result = client.search q: "Place"
        result.size.should eq(1)
        result.first.name.should eq("Place")
      end
    end

    describe "#create" do
      it "posts to the edges endpoint" do
        body = {name: "Place"}.to_json
        WebMock
          .stub(:post, DOMAIN + client.base)
          .with(
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: body,
          )
          .to_return(body: edges.first)
        result = client.create name: "Place"
        result.should be_a(Client::API::Models::Edge)
      end
    end

    describe "#token" do
      it "returns a token" do
        id = "edge123"
        token = "edge123_s3cr3t"
        WebMock
          .stub(:get, File.join(DOMAIN, client.base, "/#{id}/token"))
          .with(headers: HEADERS)
          .to_return(body: {token: token}.to_json)
        result = client.token id
        result.should eq token
      end
    end
  end
end
