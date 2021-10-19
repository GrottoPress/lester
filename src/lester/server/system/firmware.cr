struct Lester::Server::System::Firmware
  include Hapi::Resource

  getter date : String?
  getter vendor : String?
  getter version : String?
end
