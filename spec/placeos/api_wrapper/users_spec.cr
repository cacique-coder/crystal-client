require "../../spec_helper"

module PlaceOS
  describe Client::APIWrapper::Users do
    api = Client::APIWrapper.new DOMAIN
    client = Client::APIWrapper::Users.new api

    users_json = <<-JSON
    [
      {
        "authority_id": "sgrp-1234",
        "id": "user-wJHShR4Ffa",
        "email": "john@example.com",
        "email_digest": "---",
        "name": "John Doe",
        "created_at": 1555995992,
        "updated_at": 1555996000
      }
    ]
    JSON

    describe "#search" do
      it "provides user search" do
        WebMock
          .stub(:get, DOMAIN + client.base)
          .with(query: {"q" => "\"John Doe\"", "limit" => "20", "offset" => "0"})
          .to_return(body: users_json)
        result = client.search "\"John Doe\""
        result.size.should eq(1)
        result.first.email.should eq("john@example.com")
      end
    end
  end
end
