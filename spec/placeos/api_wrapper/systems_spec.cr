require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Systems do
    api = Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Systems.new api

    systems_json = {{ read_file("#{__DIR__}/mocks/systems.json") }}
    systems = Array(JSON::Any).from_json(systems_json).map &.to_json

    describe "#search" do
      it "enumerates all systems" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "1000", "offset" => "0"})
          .to_return(body: systems_json)
        result = client.search
        result.size.should eq(3)
        system = result.first
        system.should be_a(PlaceOS::Model::ControlSystem)
        system.name.should eq("Room 1")
      end

      it "provides system search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "\"Room 1\"", "limit" => "1000", "offset" => "0"})
          .to_return(body: "[#{systems.first}]")

        result = client.search "\"Room 1\""
        result.size.should eq(1)
        result.first.name.should eq("Room 1")
      end

      it "supports paging in system queries" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"limit" => "1", "offset" => "1"})
          .to_return(body: "[#{systems[1]}]")
        result = client.search limit: 1, offset: 1
        result.size.should eq(1)
        result.first.name.should eq("Room 2")
      end
    end

    describe "#create" do
      it "posts to the systems endpoint" do
        WebMock
          .stub(:post, DOMAIN + client.base)
          .with(
            headers: {"Content-Type" => "application/json"},
            body: {
              name:  "Foo",
              zones: ["a", "b", "c"],
            }.to_json
          )
          .to_return(body: systems.first)
        result = client.create name: "Foo", zones: ["a", "b", "c"]
        result.should be_a(PlaceOS::Model::ControlSystem)
      end
    end

    describe "#fetch" do
      it "inspects a systems metadata" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/sys-rJQQlR4Cn7")
          .to_return(body: systems.first)
        result = client.fetch "sys-rJQQlR4Cn7"
        result.should be_a(PlaceOS::Model::ControlSystem)
      end
    end

    describe "#update" do
      it "send a put request to the systems endpoint" do
        WebMock
          .stub(:put, DOMAIN + "#{client.base}/sys-rJQQlR4Cn7?version=2")
          .with(
            headers: {"Content-Type" => "application/json"},
            body: {version: 2, name: "Foo"}.to_json
          )
          .to_return(body: systems.first)
        result = client.update "sys-rJQQlR4Cn7", version: 2, name: "Foo"
        result.should be_a(PlaceOS::Model::ControlSystem)
      end
    end

    describe "#destroy" do
      it "execs a delete request" do
        WebMock
          .stub(:delete, DOMAIN + "#{client.base}/sys-rJQQlR4Cn7")
        result = client.destroy "sys-rJQQlR4Cn7"
        result.should be_nil
      end
    end

    describe "#start" do
      it "requests a system start" do
        WebMock
          .stub(:post, DOMAIN + "#{client.base}/sys-rJQQlR4Cn7/start")
        result = client.start "sys-rJQQlR4Cn7"
        result.should be_nil
      end
    end

    describe "#stop" do
      it "requests a system stop" do
        WebMock
          .stub(:post, DOMAIN + "#{client.base}/sys-rJQQlR4Cn7/stop")
        result = client.stop "sys-rJQQlR4Cn7"
        result.should be_nil
      end
    end

    describe "#execute" do
      it "requests a method execution within a system" do
        WebMock
          .stub(:post, DOMAIN + "#{client.base}/sys-rJQQlR4Cn7/Foo_2/test")
          .with(
            headers: {"Content-Type" => "application/json"},
            body: %([])
          )
          .to_return(body: "42")
        result = client.execute "sys-rJQQlR4Cn7", module_name: "Foo", index: 2, method: "test"
        result.should eq(42)
      end
    end

    describe "#state" do
      it "requests full module state" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/sys-rJQQlR4Cn7/Foo_2")
          .to_return(body: %({"a":1,"b":2,"c":3}))
        result = client.state "sys-rJQQlR4Cn7", module_name: "Foo", index: 2
        result.should be_a(JSON::Any)
        result["a"].as_i.should eq(1)
      end

      it "requests individual state keys" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/sys-rJQQlR4Cn7/Foo_2/a")
          .to_return(body: "1")
        result = client.state "sys-rJQQlR4Cn7", module_name: "Foo", index: 2, lookup: "a"
        result.should be_a(JSON::Any)
        result.as_i.should eq(1)
      end
    end

    describe "#functions" do
      it "requests available behaviours" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/sys-rJQQlR4Cn7/functions/Foo_2")
          .to_return(body: <<-JSON
          {
            "function_name": {
              "arity": 3,
              "params": [
                ["req", "foo"],
                ["opt", "bar"],
                ["rest", "baz"]
              ]
            }
          }
        JSON
          )
        result = client.functions "sys-rJQQlR4Cn7", module_name: "Foo", index: 2
        result.should be_a(Hash(String, Client::API::Models::Function))
      end
    end

    describe "#types" do
      it "requests module types" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/sys-rJQQlR4Cn7/types")
          .to_return(body: %({"Foo":3,"Bar":1,"Baz":5}))
        result = client.types "sys-rJQQlR4Cn7"
        result["Foo"].should eq(3)
      end
    end

    describe "#count" do
      it "requests module counts" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/sys-rJQQlR4Cn7/types")
          .to_return(body: %({"Foo":3,"Bar":1,"Baz":5}))
        result = client.count "sys-rJQQlR4Cn7", module_name: "Foo"
        result.should eq(3)
      end
    end

    describe "#with_emails" do
      it "multiple emails" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/with_emails")
          .with(query: {"in" => "room1@example.com,room3@example.com"})
          .to_return(body: "[#{systems.first},#{systems.last}]")

        result = client.with_emails ["room1@example.com", "room3@example.com"]

        result.size.should eq(2)
        result.first.name.should eq("Room 1")
        result.last.name.should eq("Room 3")
      end

      it "single email" do
        WebMock
          .stub(:get, DOMAIN + "#{client.base}/with_emails")
          .with(query: {"in" => "room1@example.com"})
          .to_return(body: "[#{systems.first}]")

        result = client.with_emails "room1@example.com"

        result.size.should eq(1)
        result.first.name.should eq("Room 1")
      end
    end

    describe "#settings" do
      WebMock
        .stub(:get, DOMAIN + "#{client.base}/sys-G03RF2BVBxP/settings")
        .to_return(body: %([{"created_at":1603948256,"updated_at":1603948256,"parent_id":"sys-G03RF2BVBxP","encryption_level":0,"settings_string":"test_setting: true","keys":["test_setting"],"parent_type":0,"id":"sets-G039XsPNCiU"}]        ))
      result = client.settings "sys-G03RF2BVBxP"
      result[0].should be_a(PlaceOS::Client::API::Models::Settings)
    end

    describe "#add_module" do
      id = "sys-G03RF2BVBxP"
      module_id = "mod-G0U3rAFy8d_"

      WebMock
        .stub(:put, DOMAIN + "#{client.base}/#{id}/module/#{module_id}")
        .to_return(body: %({"created_at":1603948255,"updated_at":1604033694,"name":"TestSystem-0ede08b5","description":"","features":["TestModule-0ede08b5","This is a custom name"],"bookable":false,"capacity":0,"support_url":"","version":2,"installed_ui_devices":0,"zones":["zone-G03PfSG4YRP"],"modules":["mod-G03EBWsV9mx","mod-G0U3rAFy8d_"],"id":"sys-G03RF2BVBxP"}))
      result = client.add_module id: id, module_id: module_id
      result.should be_a(PlaceOS::Model::Module)
    end

    describe "#remove_module" do
      id = "sys-G03RF2BVBxP"
      module_id = "mod-G0U3rAFy8d_"

      WebMock
        .stub(:delete, DOMAIN + "#{client.base}/#{id}/module/#{module_id}")
        .to_return(body: %({"created_at":1603948255,"updated_at":1604035469,"name":"TestSystem-0ede08b5","description":"","features":["TestModule-0ede08b5"],"bookable":false,"capacity":0,"support_url":"","version":3,"installed_ui_devices":0,"zones":["zone-G03PfSG4YRP"],"modules":["mod-G03EBWsV9mx"],"id":"sys-G03RF2BVBxP"}))
      result = client.remove_module id: id, module_id: module_id
      result.should be_a(PlaceOS::Model::Module)
    end

    describe "#control" do
    end
  end
end
