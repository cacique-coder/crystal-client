require "./response"

module PlaceOS::Client::API::Models
  # Metadata about the current user
  struct User < Response
    include Timestamps

    getter id : String
    getter email_digest : String
    getter nickname : String?
    getter name : String
    getter first_name : String?
    getter last_name : String?
    getter country : String?
    getter building : String?
    getter image : String?

    # Admin only fields
    getter sys_admin : Bool?
    getter support : Bool?
    getter email : String
    getter phone : String?
    getter ui_theme : String?
    getter metadata : String?
    getter login_name : String?
    getter staff_id : String?
    getter card_number : String?
    getter groups : Array(String)?
  end

  struct ResourceToken < Response
    getter token : String
    getter expires : Int64?
  end
end