require "uri"
require "./api_wrapper"

# Client for interfacing with ACAEngine.
#
# Provides API wrappers, models and abstractions over these for controlling, automating or
# interacting with ACAEngine instances and the environments they interface with.
class ACAEngine::Client
  VERSION = `shards version`

  getter uri : URI

  property auth_token : String

  def self.from_env
  end

  def initialize(base_uri : URI | String, @auth_token)
    @uri = base_uri
  end
end
