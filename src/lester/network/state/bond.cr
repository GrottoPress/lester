struct Lester::Network::State::Bond
  include Hapi::Resource

  getter down_delay : Int32?
  getter lower_devices : Array(String)?
  getter mii_frequency : Int32?
  getter mii_state : LinkState?
  getter mode : String?
  getter transmit_policy : String?
  getter up_delay : Int32?
end
