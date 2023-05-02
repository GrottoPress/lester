struct Lester::Server::System::Firmware
  include Lester::Resource

  getter date : String?
  getter vendor : String?
  getter version : String?
end
