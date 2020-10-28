require "spec"
require "../src/placeos/client"
require "webmock"
require "../src/placeos/api/models/role.cr"

Spec.before_suite &->WebMock.reset
Spec.before_each &->WebMock.reset

DOMAIN  = "https://example.place.technology"
HEADERS = HTTP::Headers{"Host" => URI.parse(DOMAIN).host.as(String)}
