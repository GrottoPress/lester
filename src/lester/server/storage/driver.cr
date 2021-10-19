struct Lester::Server::Storage::Driver
  include Hapi::Resource

  getter name : String?
  getter? remote : Bool?
  getter version : String?
end
