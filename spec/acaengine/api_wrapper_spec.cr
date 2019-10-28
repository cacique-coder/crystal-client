require "../spec_helper.cr"
require "./api_wrapper/*"

# Provide some thin wrappers for access to internals for testing.
class ACAEngine::APIWrapper
  {% for method in %w(get post put head delete patch options) %}
    def __test_{{method.id}}(path, body = nil)
      {{method.id}} path, body
    end
  {% end %}
end

describe ACAEngine::APIWrapper do
  api = ACAEngine::APIWrapper.new "http://aca.example.com"

  describe "base HTTP methods" do
    {% for method in %w(get post put head delete patch options) %}
      it "\#{{method.id}}" do
        WebMock.stub :{{method.id}}, "aca.example.com/foo"
        response = api.__test_{{method.id}} "/foo"
        response.status_code.should eq(200)
      end
    {% end %}

    it "raises an domain specific exception on error response" do
      WebMock.stub(:get, "aca.example.com/foo").to_return do
        HTTP::Client::Response.new(500)
      end
      expect_raises(ACAEngine::API::Error) do
        api.__test_get "/foo"
      end
    end
  end
end
