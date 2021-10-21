struct Lester::Cluster::Member
  include Hapi::Resource

  getter architecture : String?
  getter config : Hash(String, String)?
  getter? database : Bool?
  getter description : String?
  getter failure_domain : String?
  getter message : String?
  getter roles : Array(String)?
  getter server_name : String?
  getter status : String?
  getter url : String?
end
