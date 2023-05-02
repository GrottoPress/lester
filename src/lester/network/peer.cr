struct Lester::Network::Peer
  include Lester::Resource

  getter config : Hash(String, String)?
  getter description : String?
  getter name : String?
  getter status : String?
  getter target_network : String?
  getter target_project : String?
end
