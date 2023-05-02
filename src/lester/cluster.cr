struct Lester::Cluster
  include Lester::Resource

  getter? enabled : Bool?
  getter member_config : Array(Member::Config)?
  getter server_name : String?
end
