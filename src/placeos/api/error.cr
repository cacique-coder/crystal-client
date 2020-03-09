require "http/client/response"

class PlaceOS::API::Error < Exception
  def self.from_response(response : HTTP::Client::Response)
    if response.success?
      # Shouldn't ever be passed through here...
      raise ArgumentError.new "response is valid"
    else
      new response.status_message || "HTTP error #{response.status_code}"
    end
  end
end
