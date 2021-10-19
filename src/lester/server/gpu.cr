struct Lester::Server::Gpu
  include Hapi::Resource

  getter cards : Array(Card)?
  getter total : Int32?
end
