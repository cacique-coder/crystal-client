require "./response"

module PlaceOS::Client::API::Models
  struct Asset < Response
    # A universally unique identifier for the Asset.
    getter id : String

    # A human readable identifier.
    getter name : String

    getter category : String?

    # Markdown formatted text that describes the asset.
    getter description : String?

    getter purchase_date : Time
    getter good_until_date : Time?

    getter identifier : String?
    getter brand : String?

    # TODO: define currency for `purchase_price`
    getter purchase_price : Int32?

    # Array of URLs to images for an asset
    getter images : Array(String) = [] of String

    # URL of downloadable receipt
    getter invoice : String?

    getter quantity : Int32
    getter in_use : Int32

    getter other_data : JSON::Any = JSON::Any.new({} of String => JSON::Any)

    getter parent_id : String?
  end
end
