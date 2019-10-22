require "spec"
require "../src/acaengine/client"
require "webmock"

Spec.before_each &->WebMock.reset
