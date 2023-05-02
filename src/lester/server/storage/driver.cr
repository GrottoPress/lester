struct Lester::Server::Storage::Driver
  include Lester::Resource

  getter name : String?
  getter? remote : Bool?
  getter version : String?
end
