struct Lester::Server::Usb
  include Lester::Resource

  getter devices : Array(Device)?
  getter total : Int32?
end
