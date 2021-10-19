struct Lester::Server::System::Chassis
  include Hapi::Resource

  getter serial : String?
  getter type : String?
  getter vendor : String?
  getter version : String?
end
