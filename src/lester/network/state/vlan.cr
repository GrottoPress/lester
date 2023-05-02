struct Lester::Network::State::Vlan
  include Lester::Resource

  getter lower_device : String?
  getter vid : Int32?
end
