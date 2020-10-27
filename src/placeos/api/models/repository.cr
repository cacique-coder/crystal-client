require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model GitHub Link: https://github.com/PlaceOS/models/blob/master/src/placeos-models/repository.cr
  #
  struct Repository < Response
    getter id : String
    getter name : String
    getter uri : String
    getter repo_type : String
    getter username : String
    getter password : String
    getter key : String
    getter folder_name : String?
    getter description : String?
    getter commit_hash : String?
    getter branch : String?
    getter repo_type : Type?
    getter username : String?
    getter password : String?
    getter key : String?
  end

  enum Type
    Driver
    Interface
  end
end
