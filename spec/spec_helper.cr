require "spec"
require "../src/placeos/client"
require "webmock"

Spec.before_each &->WebMock.reset
