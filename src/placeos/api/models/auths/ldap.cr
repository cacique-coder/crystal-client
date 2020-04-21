require "../response"

module PlaceOS::Client::API::Models
  struct LdapAuthentication < Response
    getter name : String
    getter authority_id : String
    getter port : Int32

    # Options are: plain, ssl, tls
    getter auth_method : String
    getter uid : String
    getter host : String

    # BaseDN such as dc=intridea, dc=com
    getter base : String

    # :bind_dn and :password is the default credentials to perform user lookup
    getter bind_dn : String
    getter password : String

    # LDAP filter like: (&(uid=%{username})(memberOf=cn=myapp-users,ou=groups,dc=example,dc=com))
    # Can be used instead of UID
    getter filter : String
  end
end
