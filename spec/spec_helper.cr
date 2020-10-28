require "spec"
require "../src/placeos/client"
require "webmock"
require "../src/placeos/api/models/role.cr"

Spec.before_suite &->WebMock.reset
Spec.before_each &->WebMock.reset

DOMAIN  = "https://example.place.technology"
HEADERS = HTTP::Headers{"Host" => URI.parse(DOMAIN).host.as(String)}

CLIENT_ID = "b52e653071c45353dbff4e8f47d51cdf"
PLACEOS_URI = URI.parse("https://localhost:8443")

def client
  PlaceOS::Client.new(
    base_uri: PLACEOS_URI,
    email: "support@place.tech",
    password: "development",
    client_id: CLIENT_ID,
    client_secret: "",
  )
end

def with_client(& : PlaceOS::Client ->)
  yield client
end