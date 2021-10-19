struct Lester::Server::Usb
  include Hapi::Resource

  getter devices : Array(Device)?
  getter total : Int32?
end
