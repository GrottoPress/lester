struct Lester::Network::State
  include Lester::Resource

  getter addresses : Array(Address)?
  getter bond : Bond?
  getter bridge : Bridge?
  getter counters : Counters?
  getter hwaddr : String?
  getter host_name : String?
  getter mtu : Int64?
  getter state : LinkState?
  getter type : String?
  getter vlan : Vlan?
end
