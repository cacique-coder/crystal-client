require "json"
require "../api/models/authority"

class ACAEngine::APIWrapper
  # Gets the authority metadata for the attached instance.
  def authority
    get "/api/auth/authority", as: Authority
  end
end
