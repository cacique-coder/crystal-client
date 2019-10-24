require "json"
require "../api/models/authority"

class ACAEngine::APIWrapper
  # Gets the authority metadata for the attached instance.
  def authority : Authority
    response = get "/api/auth/authority"
    Authority.from_json response.body
  end
end
