struct Lester::Server::System::Motherboard
  include Hapi::Resource

  getter product : String?
  getter serial : String?
  getter vendor : String?
  getter version : String?
end
