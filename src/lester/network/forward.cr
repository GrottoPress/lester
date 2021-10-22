struct Lester::Network::Forward
  include Hapi::Resource

  getter config : Hash(String, String)?
  getter description : String?
  getter listen_address : String?
  getter location : String?
  getter ports : Array(Port)?
end
