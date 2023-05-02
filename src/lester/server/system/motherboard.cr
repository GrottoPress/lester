struct Lester::Server::System::Motherboard
  include Lester::Resource

  getter product : String?
  getter serial : String?
  getter vendor : String?
  getter version : String?
end
