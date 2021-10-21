struct Lester::Cluster
  include Hapi::Resource

  getter? enabled : Bool?
  getter member_config : Array(Member::Config)?
  getter server_name : String?
end
