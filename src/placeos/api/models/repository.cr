require "./response"

module PlaceOS::Client::API::Models
  struct Repository < Response
    enum Type
      Driver
      Interface

      def to_reql
        JSON::Any.new(to_s)
      end
    end

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
    getter repo_type : Type
  end
end
