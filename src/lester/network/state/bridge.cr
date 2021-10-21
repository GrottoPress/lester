struct Lester::Network::State::Bridge
  include Hapi::Resource

  getter forward_delay : Int32?
  getter id : String?
  getter? stp : Bool?
  getter upper_devices : Array(String)?
  getter vlan_default : Int32?
  getter? vlan_filtering : Bool?
end
