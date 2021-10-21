struct Lester::Network::Acl
  include Hapi::Resource

  getter config : Hash(String, String)?
  getter description : String?
  getter egress : Array(Rule)?
  getter ingress : Array(Rule)?
  getter name : String?
  getter used_by : Array(String)?
end
