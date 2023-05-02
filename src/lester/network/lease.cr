struct Lester::Network::Lease
  include Lester::Resource

  getter address : String?
  getter hostname : String?
  getter hwaddr : String?
  getter location : String?
  getter type : Type?
end
