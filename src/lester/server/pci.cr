struct Lester::Server::Pci
  include Hapi::Resource

  getter devices : Array(Device)?
  getter total : Int32?
end
