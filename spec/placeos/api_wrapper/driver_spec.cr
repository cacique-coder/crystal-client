require "../../spec_helper"
require "placeos-models"

# driver1 = Generator.driver(role: Driver::Role::Service)

module PlaceOS
  include Client::API::Models
  include PlaceOS::Model

  describe Client::APIWrapper::Drivers do
    api = PlaceOS::Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Drivers.new api

    drivers_json = {{ read_file("#{__DIR__}/mocks/drivers.json") }}
    drivers = Array(JSON::Any).from_json(drivers_json).map &.to_json

    # driver1 = Generator.driver(role: Driver::Role::Service)
    # driver1 = driver(1, "module_name", "repo_name")
    # puts driver1

    describe "#search" do
      it "enumerates all drivers" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: drivers_json)
        result = client.search
        result.size.should eq(2)
        driver = result.first
        driver.should be_a(Client::API::Models::Driver)
        driver.name.should eq("Place")
      end

      it "provides driver search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "Place", "limit" => "20", "offset" => "0"}, headers: HEADERS)
          .to_return(body: drivers_json)
        result = client.search q: "Place"
        result.size.should eq(2)
        result.first.name.should eq("Place")
      end

      # TODO
      # expecting 1 getting 2.
      pending "can limit pages correctly" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "1", "offset" => "0"}, headers: HEADERS)
          .to_return(body: drivers_json)
        result = client.search limit: 1
        result.size.should eq(1)
        # result.first.name.should eq("Place")
      end
    end

    describe "#create" do
      it "posts to the drivers endpoint" do
        body = {name: "Place", role: Role::Device, commit: "string", file_name: "string", module_name: "string", repository_id: "string"}.to_json
        WebMock
          .stub(:post, DOMAIN + client.base)
          .with(
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: body
          )
          .to_return(body: drivers.first)
        result = client.create(name: "Place", role: Role::Device, commit: "string", file_name: "string", module_name: "string", repository_id: "string")
        result.should be_a(Client::API::Models::Driver)
        result.to_json.should eq("{\"created_at\":1562041110,\"updated_at\":1562041120,\"id\":\"driver-oOj2lGgsz\",\"name\":\"Place\",\"description\":\"null\",\"default_uri\":\"hello\",\"default_port\":80,\"role\":1,\"file_name\":\"string\",\"commit\":\"string\",\"repository_id\":\"string\",\"module_name\":\"string\",\"ignore_connected\":true}")
      end
    end

    describe "#fetch" do
      it "inspects a drivers metadata" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/driver-oOj2lGgsz")
          .to_return(body: drivers.first)
        result = client.fetch "driver-oOj2lGgsz"
        result.should be_a(Client::API::Models::Driver)
        result.to_json.should eq("{\"created_at\":1562041110,\"updated_at\":1562041120,\"id\":\"driver-oOj2lGgsz\",\"name\":\"Place\",\"description\":\"null\",\"default_uri\":\"hello\",\"default_port\":80,\"role\":1,\"file_name\":\"string\",\"commit\":\"string\",\"repository_id\":\"string\",\"module_name\":\"string\",\"ignore_connected\":true}")
      end
    end

    describe "#update" do
      it "send a put request to the drivers endpoint" do
        WebMock
          .stub(:put, DOMAIN + "#{client.base}/driver-oOj2lGgsz")
          .with(
            headers: {"Content-Type" => "application/json"},
            body: {name: "Foo"}.to_json
          )
          .to_return(body: drivers.first)
        result = client.update "driver-oOj2lGgsz", name: "Foo"
        result.should be_a(Client::API::Models::Driver)
        result.to_json.should eq("{\"created_at\":1562041110,\"updated_at\":1562041120,\"id\":\"driver-oOj2lGgsz\",\"name\":\"Place\",\"description\":\"null\",\"default_uri\":\"hello\",\"default_port\":80,\"role\":1,\"file_name\":\"string\",\"commit\":\"string\",\"repository_id\":\"string\",\"module_name\":\"string\",\"ignore_connected\":true}")
      end
    end

    describe "#destroy" do
      it "execs a delete request" do
        WebMock
          .stub(:delete, DOMAIN + "#{client.base}/driver-oOj2lGgsz")
        result = client.destroy "driver-oOj2lGgsz"
        result.should be_nil
      end
    end

    describe "#recompile" do
      it "execs recompile" do
        WebMock
          .stub(:post, DOMAIN + "#{client.base}/driver-oOj2lGgsz/recompile")
          .to_return(body: drivers.first)
        result = client.recompile "driver-oOj2lGgsz"
        result.should be_a(Client::API::Models::Driver)
        result.to_json.should eq("{\"created_at\":1562041110,\"updated_at\":1562041120,\"id\":\"driver-oOj2lGgsz\",\"name\":\"Place\",\"description\":\"null\",\"default_uri\":\"hello\",\"default_port\":80,\"role\":1,\"file_name\":\"string\",\"commit\":\"string\",\"repository_id\":\"string\",\"module_name\":\"string\",\"ignore_connected\":true}")
      end
    end

    describe "#compiled" do
      it "execs compile" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/driver-oOj2lGgsz/compiled")
          .to_return(body: drivers.first)
        result = client.compiled "driver-oOj2lGgsz"
        result.should be_a(Client::API::Models::Driver)
        result.to_json.should eq("{\"created_at\":1562041110,\"updated_at\":1562041120,\"id\":\"driver-oOj2lGgsz\",\"name\":\"Place\",\"description\":\"null\",\"default_uri\":\"hello\",\"default_port\":80,\"role\":1,\"file_name\":\"string\",\"commit\":\"string\",\"repository_id\":\"string\",\"module_name\":\"string\",\"ignore_connected\":true}")
      end
    end
  end
end
