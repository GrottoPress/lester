struct Lester::Cluster::Member::Config
  include Lester::Resource

  getter description : String?
  getter entity : String?
  getter key : String?
  getter name : String?
  getter value : String?
end
