struct Lester::Server::System::Chassis
  include Lester::Resource

  getter serial : String?
  getter type : String?
  getter vendor : String?
  getter version : String?
end
