require "./response"

module PlaceOS::Client::API::Models
  struct AssetInstance < Response
    enum Tracking
      InStorage
      OnTheWay
      InRoom
      Returned
    end

    # A universally unique identifier for the Asset.
    getter id : String

    getter name : String

    getter tracking : Tracking = Tracking::InStorage
    getter approval : Bool

    getter asset_id : String
    getter requester_id : String?
    getter zone_id : String?

    getter usage_start : Time?
    getter usage_end : Time?
  end
end
