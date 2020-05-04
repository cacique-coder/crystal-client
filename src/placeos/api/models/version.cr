require "./response"
require "./trigger"

module PlaceOS::Client::API::Models
  struct Version < Response
    # The PlaceOS application name
    getter app : String

    # The version in the shard yml
    getter version : String

    # the commit hash for the running build
    getter commit : String

    # The build time of the docker container
    getter build_time : String
  end
end
