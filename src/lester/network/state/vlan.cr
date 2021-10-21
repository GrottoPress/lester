struct Lester::Network::State::Vlan
  include Hapi::Resource

  getter lower_device : String?
  getter vid : Int32?
end
