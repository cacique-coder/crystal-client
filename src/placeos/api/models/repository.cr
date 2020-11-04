require "./response"

module PlaceOS::Client::API::Models
  struct Repository < Response
    getter id : String
    getter name : String
    getter repo_name : String
    getter username : String
    getter password : String
    getter key : String
    getter folder_name : String
    getter description : String
    getter commit_hash : String
    getter branch : String

    @[JSON::Field(converter: PlaceOS::Client::API::Models::RepositoryConverter)]
    getter repo_type : PlaceOS::Model::Repository::Type
  end

  module RepositoryConverter
    def self.from_json(pull : JSON::PullParser) : PlaceOS::Model::Repository::Type
      PlaceOS::Model::Repository::Type.parse(pull.read_string)
    end

    def self.to_json
      json.string(self)
    end
  end
end
