require "./response"

module PlaceOS::Client::API::Models
  # PlaceOS::Model GitHub Link: https://github.com/PlaceOS/models/blob/master/src/placeos-models/user.cr
  #
  # Metadata about the current user
  struct User < Response
    include Timestamps

    getter id : String

    getter name : String
    getter nickname : String

    getter country : String
    getter image : String

    getter first_name : String
    getter last_name : String
    getter building : String

    getter email_digest : String

    # Admin only fields
    getter email : String?
    getter phone : String?

    getter ui_theme : String?

    getter login_name : String?
    getter staff_id : String?

    getter card_number : String?

    getter groups : Array(String)?

    getter sys_admin : Bool?
    getter support : Bool?

    getter metadata : String?
  end

  struct ResourceToken < Response
    getter token : String
    getter expires : Int64?
  end
end
