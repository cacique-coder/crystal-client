require "./response"

module PlaceOS::Client::API::Models
  struct Driver < Response
    include Timestamps
    getter name : String
    getter description : String

    getter default_uri : String
    getter default_port : Int32

    @[JSON::Field(converter: PlaceOS::Client::API::Models::DriverRoleConverter)]
    getter role : PlaceOS::Model::Driver::Role

    # Driver version management

    getter file_name : String # Path to driver, relative to repository directory
    getter commit : String    # Commit/version of driver to compile

    getter repository_id : String

    # Module instance configuration
    getter module_name : String

    # Don't include this module in statistics or disconnected searches
    # Might be a device that commonly goes offline (like a PC or Display that only supports Wake on Lan)
    getter ignore_connected : Bool
  end

  module DriverRoleConverter
    def self.from_json(pull : JSON::PullParser) : PlaceOS::Model::Driver::Role
      PlaceOS::Model::Driver::Role.parse(pull.read_string)
    end

    def self.to_json
      json.string(self)
    end
  end
end
