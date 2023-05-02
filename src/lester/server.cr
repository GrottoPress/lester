struct Lester::Server
  include Lester::Resource

  getter api_extensions : Array(String)?
  getter api_status : ApiStatus?
  getter api_version : String?
  getter auth : Auth?
  getter auth_methods : Array(AuthMethod)?
  getter config : Hash(String, JSON::Any)?
  getter environment : Environment?
  getter? public : Bool?
end
