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
    getter repo_type : PlaceOS::Model::Repository::Type
  end
end
