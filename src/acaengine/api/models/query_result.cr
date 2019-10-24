require "json"

struct ACAEngine::API::Models::QueryResult(T)
  include JSON::Serializable

  # The total number of results matching the query. This includes the full count
  # available, but not shown in *results* due to paging limits.
  @[JSON::Field]
  getter total : Int32

  # Results from the query.
  @[JSON::Field]
  getter results : Array(T)
end
