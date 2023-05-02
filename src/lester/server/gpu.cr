struct Lester::Server::Gpu
  include Lester::Resource

  getter cards : Array(Card)?
  getter total : Int32?
end
