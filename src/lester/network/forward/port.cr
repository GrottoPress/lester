struct Lester::Network::Forward::Port
  include Lester::Resource

  getter description : String?
  getter listen_port : String?
  getter protocol : Protocol?
  getter target_address : String?
  getter target_port : String?
end
