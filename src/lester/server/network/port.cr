struct Lester::Server::Network::Port
  include Hapi::Resource

  enum Duplex
    Half
    Full
  end

  struct Infiniband
    include Hapi::Resource

    getter issm_device : String?
    getter issm_name : String?
    getter mad_device : String?
    getter mad_name : String?
    getter verb_device : String?
    getter verb_name : String?
  end

  getter address : String?
  getter? auto_negotiation : Bool?
  getter id : String?
  getter infiniband : Infiniband?
  getter? link_detected : Bool?
  getter link_duplex : Duplex?
  getter link_speed : Int32?
  getter port : Int32?
  getter port_type : String?
  getter protocol : String?
  getter supported_modes : Array(String)?
  getter supported_ports : Array(String)?
  getter transceiver_type : String? # "internal"
end
