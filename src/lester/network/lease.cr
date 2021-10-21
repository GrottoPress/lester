struct Lester::Network::Lease
  include Hapi::Resource

  getter address : String?
  getter hostname : String?
  getter hwaddr : String?
  getter location : String?
  getter type : Type?
end
