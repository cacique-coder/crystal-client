require "json"

struct ACAEngine::API::Models::Authority
  include JSON::Serializable

  # A universally unique identifier that represents the Authority.
  @[JSON::Field]
  getter id : String

  #  JSON.mapping({
  #    # Foo
  #    id: {setter: false, type: String},
  #
  #    # Bar
  #    name:        {setter: false, type: String},
  #    domain:      {setter: false, key: "dom", type: String},
  #    description: {setter: false, type: String?},
  #    login_url:   {setter: false, type: String},
  #    logout_url:  {setter: false, type: String},
  #    config:      {setter: false, type: ::JSON::Any},
  #    session:     {setter: false, type: Bool},
  #    production:  {setter: false, type: Bool},
  #  })
end
