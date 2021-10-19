struct Lester::Server::Network
  include Hapi::Resource

  getter cards : Array(Card)?
  getter total : Int32?
end
